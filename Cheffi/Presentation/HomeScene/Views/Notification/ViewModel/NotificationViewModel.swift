//
//  NotificationViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import Combine

struct NotificationViewModelActions {
}

protocol NotificationViewModelInput {
    func viewDidLoad()
}

protocol NotificationViewModelOutput {
    var notificationsPublisher: AnyPublisher<[Notification], Never> { get }
    var errorPublisher: AnyPublisher<DataTransferError, Never> { get }
}

typealias NotificationViewModelType = NotificationViewModelInput & NotificationViewModelOutput

final class NotificationViewModel: NotificationViewModelType {
    private let actions: NotificationViewModelActions
    private let useCase: NotificationUseCase
    private let _viewDidLoad = PassthroughSubject<Void, Never>()
    private let _notifications = PassthroughSubject<[Notification], Never>()
    private let _error = PassthroughSubject<DataTransferError, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(actions: NotificationViewModelActions,
         useCase: NotificationUseCase) {
        self.actions = actions
        self.useCase = useCase
//        bind()
        testBind()
    }
    
    private func bind() {
        _viewDidLoad
            .flatMap { [unowned self] _ in
                self.useCase.execute()
                    .catch { error -> Empty<[Notification], Never> in
                        self._error.send(error)
                        return .init()
                    }
            }
            .sink { [weak self] notifications in
                self?._notifications.send(notifications)
            }
            .store(in: &cancellables)
    }
    
    private func testBind() {
        _viewDidLoad
            .flatMap { _ in
                let dummyNotifications = [
                    Notification(notificationType: .post, content: "‘김쉐피'님께서 새로운 게시글을 등록했어요"),
                    Notification(notificationType: .like, content: "‘그시절낭만의 근본 경양식 돈가스’의 글이 유료전환까지 1시간 남았어요"),
                    Notification(notificationType: .follow, content: "‘최쉐피'님께서 나를 팔로우 했어요"),
                    Notification(notificationType: .notice, content: "‘마이크 테스트’ 게시글이 등록 되었어요"),
                    Notification(notificationType: .post, content: "내가 쓴 ‘경양식 돈가스’의 글이 인기 급등 맛집으로 선정되었어요"),
                    Notification(notificationType: .notice, content: "‘마이크 테스트’ 게시글이 등록 되었어요")
                ]
                return Just(dummyNotifications)
            }
            .sink { [weak self] notifications in
                self?._notifications.send(notifications)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Input
    func viewDidLoad() {
        _viewDidLoad.send()
    }
    
    // MARK: - Output
    var notificationsPublisher: AnyPublisher<[Notification], Never> {
        _notifications.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<DataTransferError, Never> {
        _error.eraseToAnyPublisher()
    }
}

