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
    func notificationRemove(at index: Int)
    func notificationRemoveAll()
    func selectIndexPathRemove(at indexPath: IndexPath)
    func selectIndexPathsRemoveAll()
    func selectIndexPathAppend(_ indexPath: IndexPath)
    func setDeleting(_ status: Bool)
    func readNotoficationAppend(at id: String)
    func readNotificationRemoveAll()
    func readNotificationRemove(at indexPath: IndexPath)
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
                self?._notifications.send(notifications)
            }.store(in: &cancellables)
    }
    
    // MARK: - Input
    func viewDidLoad() {
        _viewDidLoad.send()
    }
    
    func notificationRemove(at index: Int) {
        var currentNotifications = _notifications.value
        currentNotifications.remove(at: index)
        _notifications.send(currentNotifications)
    }
    
    func notificationRemoveAll() {
        _notifications.send([])
    }
    
    func selectIndexPathRemove(at indexPath: IndexPath) {
        _selectIndexPaths.value.removeAll(indexPath)
    }
    
    func selectIndexPathsRemoveAll() {
        _selectIndexPaths.value.removeAll()
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
    
    func readNotificationRemoveAll() {
        UserDefaultsManager.NotificationClear()
    }
    
    func readNotificationRemove(at indexPath: IndexPath) {
        guard let selectIndexPath = _selectIndexPaths.value.first(where: { $0 == indexPath }),
              let notification = _notifications.value[safe: selectIndexPath.row],
              let notificationId = UserDefaultsManager.NotificationInfo.notificationIds.first(where: { $0 == notification.id })  else { return }
        UserDefaultsManager.NotificationInfo.notificationIds.removeAll(notificationId)
        print("---------------------------------------")
        print("삭제 한 ID : ", notificationId)
        print("---------------------------------------")
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
