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
    func readNotoficationAppend(at id: Int)
    func scrolledToBottom()
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
    func isReadNotification(at id: Int) -> Bool
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
    private var _scrolledToBottom = PassthroughSubject<Void, Never>()
    private var readNotificationIds: [String] = []
    
    private let paginationGenerator =  DefaultPaginationGenerator<Notification>(cursor: 0, size: 10)

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
                return self.fetchContents()
                    .catch { error -> Empty<[Notification], Never> in
                        self._error.send(error)
                        return .init()
                    }
            }.sink { [weak self] notifications in
                self?._notifications.send(notifications)
            }.store(in: &cancellables)
        
        _scrolledToBottom
            .filter { self.paginationGenerator.fetchStatus == .ready }
            .flatMap { [unowned self] _ in
                return self.fetchContents()
                    .catch { error -> Empty<[Notification], Never> in
                        self._error.send(error)
                        return .init()
                    }
            }.sink { [weak self] notifications in
                guard let self else { return }
                self._notifications.send(self._notifications.value + notifications)
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
    
    private func fetchContents() -> AnyPublisher<[Notification], DataTransferError> {
        let result = CurrentValueSubject<[Notification], DataTransferError>([Notification]())
        
        paginationGenerator.next(
            fetch: { cursor, size, onCompletion, onError in
                let notificationRequest: NotificationRequest = NotificationRequest(cursor: cursor, size: size)
                let notifications: AnyPublisher<[Notification], DataTransferError> = useCase.getNotifications(notificationRequest: notificationRequest)
                
                notifications
                    .sink(receiveCompletion: { completion in
                        switch completion {
                            // TODO: 에러 처리
                        case .failure(let error):
                            onError(error)
                        case .finished:
                            break
                        }
                    }, receiveValue: { contents in
                        onCompletion(contents)
                    }).store(in: &self.cancellables)
            }, onCompletion: {
                result.send($0)
            }, onError: {
                if let dataTransferError = $0 as? DataTransferError {
                    result.send(completion: .failure(dataTransferError))
                }
            }
        )
        
        return result
            .eraseToAnyPublisher()
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
                ids.append(String(id))
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
    
    func readNotoficationAppend(at id: Int) {
        UserDefaultsManager.NotificationInfo.notificationIds.append(id)
    }
    
    func scrolledToBottom() {
        _scrolledToBottom.send(())
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
    
    func isReadNotification(at id: Int) -> Bool {
        return UserDefaultsManager.NotificationInfo.notificationIds.contains([id])
    }
    
    func showPopup(text: String, subText: String, keywrod: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String, leftHandler: (() -> Void)?, rightHandler: (() -> Void)?) {
        actions.showPopup(text, subText, keywrod, popupState, leftButtonTitle, rightButtonTitle, leftHandler, rightHandler)
    }
}
