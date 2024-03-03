//
//  NotificationViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Combine
import Foundation

struct NotificationViewModelActions {
    let showPopup: (_ text: String,_ subText: String, _ keyword: String, _ popupState: PopupState, _ leftButtonTitle: String, _ rightButtonTitle: String, _ leftHandler: (() -> Void)?, _ rightHandler: (() -> Void)?) -> Void
}

protocol NotificationViewModelInput {
    func viewDidLoad()
    func notificationRemove(at indexPaths: [IndexPath])
    func notificationRemoveAll()
    func selectIndexPathRemove(at indexPaths: [IndexPath])
    func selectIndexPathAppend(_ indexPath: IndexPath)
    func setDeleting(_ status: Bool)
    func readNotoficationAppend(at id: String)
}

protocol NotificationViewModelOutput {
    var notificationsPublisher: AnyPublisher<[Notification], Never> { get }
    var errorPublisher: AnyPublisher<DataTransferError, Never> { get }
    var isDeletingPublisher: AnyPublisher<Bool, Never> { get }
    var isDeleting: Bool { get }
    var selectIndexPathsPublisher: AnyPublisher<[IndexPath], Never> { get }
    var selectIndexPaths: [IndexPath] { get }
    var numberOfNotifications: Int { get }
    func notification(at index: Int) -> Notification?
    func isReadNotification(at id: String) -> Bool
    func showPopup(text: String, subText: String, keywrod: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String, leftHandler: (() -> Void)?, rightHandler: (() -> Void)?)
}

typealias NotificationViewModelType = NotificationViewModelInput & NotificationViewModelOutput

final class NotificationViewModel: NotificationViewModelType {
    private let actions: NotificationViewModelActions
    private let useCase: NotificationUseCase
    private let _viewDidLoad = PassthroughSubject<Void, Never>()
    private let _notifications = CurrentValueSubject<[Notification], Never>([])
    private let _error = PassthroughSubject<DataTransferError, Never>()
    private var cancellables: Set<AnyCancellable> = []
    private var _isDeleting = CurrentValueSubject<Bool, Never>(false)
    private var _selectIndexPaths = CurrentValueSubject<[IndexPath], Never>([])
    private var readNotificationIds: [String] = []
    
    
    // MARK: - Init
    init(actions: NotificationViewModelActions,
         useCase: NotificationUseCase) {
        self.actions = actions
        self.useCase = useCase
        bind()
    }
    
    private func bind() {
        _viewDidLoad
            .flatMap { [unowned self] _ in
                let notificationRequest: NotificationRequest = NotificationRequest(cursor: 0, size: 10)
                return self.useCase.getNotifications(notificationRequest: notificationRequest)
                    .catch { error -> Empty<[Notification], Never> in
                        self._error.send(error)
                        return .init()
                    }
            }.sink { [weak self] notifications in
                let dummyNotifications = [
                    Notification(id: "1", category: .review, content: "‘김쉐피'님께서 새로운 게시글을 등록했어요", checked: true, notifiedDate: ""),
                    Notification(id: "2", category: .bookmark, content: "‘그시절낭만의 근본 경양식 돈가스’의 글이 유료전환까지 1시간 남았어요", checked: true, notifiedDate: ""),
                    Notification(id: "3", category: .follow, content: "‘최쉐피'님께서 나를 팔로우 했어요", checked: true, notifiedDate: ""),
                    Notification(id: "4", category: .official, content: "‘마이크 테스트’ 게시글이 등록 되었어요", checked: true, notifiedDate: ""),
                    Notification(id: "5", category: .review, content: "내가 쓴 ‘경양식 돈가스’의 글이 인기 급등 맛집으로 선정되었어요", checked: true, notifiedDate: ""),
                    Notification(id: "6", category: .official, content: "‘마이크 테스트’ 게시글이 등록 되었어요", checked: true, notifiedDate: "")
                ]
                self?._notifications.send(dummyNotifications)
//                self?._notifications.send(notifications)
            }.store(in: &cancellables)
    }
        
    private func readNotificationRemove(at indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            guard let selectIndexPath = _selectIndexPaths.value.first(where: { $0 == indexPath }),
                  let notification = _notifications.value[safe: selectIndexPath.row],
                  let notificationId = UserDefaultsManager.NotificationInfo.notificationIds.first(where: { $0 == notification.id }) else { return }
            
            UserDefaultsManager.NotificationInfo.notificationIds.removeAll(notificationId)
            print("---------------------------------------")
            print("삭제 한 ID : ", notificationId)
            print("---------------------------------------")
        }
    }
    
    private func selectIndexPathsRemoveAll() {
        _selectIndexPaths.value.removeAll()
    }
    
    private func readNotificationRemoveAll() {
        UserDefaultsManager.NotificationClear()
    }
    
    // MARK: - Input
    func viewDidLoad() {
        _viewDidLoad.send()
    }
    
    /// 현재 토큰인증 작업이 안되었으므로 해당 메서드 정상 작동 X ---> 크래시 발생
    func notificationRemove(at indexPaths: [IndexPath]) {
        let indexes = indexPaths.map { $0.item }
        var currentNotifications = _notifications.value
        
        var ids: [String] = []
        indexes.forEach {
            if let id = currentNotifications[safe: $0]?.id {
                ids.append(id)
            }

            currentNotifications.remove(at: $0)
        }
        
        useCase.deleteNotifications(ids: ids, deleteAll: false)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    // TODO: 에러 처리
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.readNotificationRemove(at: indexPaths)
                self?.selectIndexPathRemove(at: indexPaths)
                self?._notifications.send(currentNotifications)
            }.store(in: &cancellables)
    }
    
    func notificationRemoveAll() {
        useCase.deleteNotifications(ids: [], deleteAll: true)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    // TODO: 에러 처리
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.selectIndexPathsRemoveAll()
                self?.readNotificationRemoveAll()
                self?._notifications.send([])
            }.store(in: &cancellables)
    }
    
    func selectIndexPathRemove(at indexPaths: [IndexPath]) {
        indexPaths.forEach {
            _selectIndexPaths.value.removeAll($0)
        }
    }
        
    func selectIndexPathAppend(_ indexPath: IndexPath) {
        _selectIndexPaths.value.append(indexPath)
    }
    
    func setDeleting(_ status: Bool) {
        _isDeleting.send(status)
    }
    
    func readNotoficationAppend(at id: String) {
        UserDefaultsManager.NotificationInfo.notificationIds.append(id)
    }
        
    // MARK: - Output
    var notificationsPublisher: AnyPublisher<[Notification], Never> {
        _notifications.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<DataTransferError, Never> {
        _error.eraseToAnyPublisher()
    }
    
    var selectIndexPathsPublisher: AnyPublisher<[IndexPath], Never> {
        _selectIndexPaths.eraseToAnyPublisher()
    }
    
    var selectIndexPaths: [IndexPath] {
        _selectIndexPaths.value
    }
    
    var isDeletingPublisher: AnyPublisher<Bool, Never> {
        _isDeleting.eraseToAnyPublisher()
    }
    
    var isDeleting: Bool {
        _isDeleting.value
    }
    
    var numberOfNotifications: Int {
        _notifications.value.count
    }
    
    func notification(at index: Int) -> Notification? {
        return _notifications.value[safe: index]
    }
    
    func isReadNotification(at id: String) -> Bool {
        return UserDefaultsManager.NotificationInfo.notificationIds.contains([id])
    }
    
    func showPopup(text: String, subText: String, keywrod: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String, leftHandler: (() -> Void)?, rightHandler: (() -> Void)?) {
        actions.showPopup(text, subText, keywrod, popupState, leftButtonTitle, rightButtonTitle, leftHandler, rightHandler)
    }
}
