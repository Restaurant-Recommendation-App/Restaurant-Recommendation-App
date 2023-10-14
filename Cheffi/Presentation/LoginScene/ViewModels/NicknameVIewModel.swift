//
//  NicknameVIewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/09.
//

import Foundation
import Combine

enum NicknameMessageStatus {
    case numberOfCharError
    case duplicateError
    case success
    case none
}

protocol NicknameViewModelInput {
    var nicknameSubject: PassthroughSubject<String, Never> { get }
    func updateMessageAndStatus(isInuse: Bool)
    func checkNicknameDuplicationDidTap()
    func patchNicknameDidTap()
    func saveToLocalDB(nickname: String)
}

protocol NicknameViewModelOutput {
    var isInuseNickname: AnyPublisher<Bool, DataTransferError> { get }
    var isDuplicationCheckButtonEnabled: AnyPublisher<Bool, Never> { get }
    var message: AnyPublisher<String?, Never> { get }
    var messageStatus: AnyPublisher<NicknameMessageStatus, Never> { get }
    var maxNicknameCount: Int { get }
    var patchNickname: AnyPublisher<String?, DataTransferError> { get }
    func showMessageForExceedingMaxCount()
}

protocol NicknameViewModelType {
    var input: NicknameViewModelInput { get }
    var output: NicknameViewModelOutput { get }
}

class NicknameViewModel: NicknameViewModelType {
    var input: NicknameViewModelInput { return self }
    var output: NicknameViewModelOutput { return self }
    
    private var cancellables: Set<AnyCancellable> = []
    private var _messageStatus = CurrentValueSubject<NicknameMessageStatus, Never>(.none)
    private var _message = CurrentValueSubject<String?, Never>("")
    private var _isDuplicationCheckButtonEnabled = CurrentValueSubject<Bool, Never>(false)
    private var _nickname: String? = nil
    private var _nicknameSubject = PassthroughSubject<String, Never>()
    private var checkNicknameDuplicationDidTapSubject = PassthroughSubject<Void, Never>()
    private var patchNicknameDidTapSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    private let useCase: AuthUseCase
    init(useCase: AuthUseCase) {
        self.useCase = useCase
        bind()
    }
    
    // MARK: - Private
    private func bind() {
        _nicknameSubject
            .sink { [weak self, maxNicknameCount, _isDuplicationCheckButtonEnabled, _message, _messageStatus] nickname in
                self?._nickname = nickname
                if nickname.count != maxNicknameCount {
                    _isDuplicationCheckButtonEnabled.send(nickname.count >= 2)
                    _message.send("")
                    _messageStatus.send(.none)
                }
            }
            .store(in: &cancellables)
    }
    
    private func getNicknameInuse(nickname: String) -> AnyPublisher<Bool, DataTransferError> {
        let subject = PassthroughSubject<Bool, DataTransferError>()
        
        useCase.getNicknameInuse(nickname: nickname)
            .print("getNicknameInuse")
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { isInuse, _ in
                subject.send(isInuse)
            }
            .store(in: &cancellables)

        return subject.eraseToAnyPublisher()
    }
    
    private func patchNickname(nickname: String) -> AnyPublisher<String?, DataTransferError> {
        let subject = PassthroughSubject<String?, DataTransferError>()
        useCase.patchNickname(nickname: nickname)
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { (nickname, _) in
                subject.send(nickname)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Input
extension NicknameViewModel: NicknameViewModelInput {
    var nicknameSubject: PassthroughSubject<String, Never> {
        _nicknameSubject
    }
    
    func patchNicknameDidTap() {
        patchNicknameDidTapSubject.send(())
    }
    
    func checkNicknameDuplicationDidTap() {
        checkNicknameDuplicationDidTapSubject.send(())
    }
    
    func updateMessageAndStatus(isInuse: Bool) {
        if isInuse {
            _message.send("이미 사용중인 닉네임 입니다.")
            _messageStatus.send(.duplicateError)
        } else {
            _message.send("사용 가능한 닉네임이에요 !")
            _messageStatus.send(.success)
        }
    }
    
    func saveToLocalDB(nickname: String) {
        UserDefaultsManager.AuthInfo.user = UserDefaultsManager.AuthInfo.user?.updateNickname(text: nickname)
    }
}

// MARK: Output
extension NicknameViewModel: NicknameViewModelOutput {
    var maxNicknameCount: Int {
        8
    }
    
    var isInuseNickname: AnyPublisher<Bool, DataTransferError> {
        return checkNicknameDuplicationDidTapSubject
            .flatMap { [weak self] _ -> AnyPublisher<Bool, DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success(true))
                    }.eraseToAnyPublisher()
                }
                
                return self.getNicknameInuse(nickname: _nickname ?? "")
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var patchNickname: AnyPublisher<String?, DataTransferError> {
        return patchNicknameDidTapSubject
            .flatMap { [weak self] _ -> AnyPublisher<String?, DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success(nil))
                    }.eraseToAnyPublisher()
                }
                return self.patchNickname(nickname: _nickname ?? "")
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var isDuplicationCheckButtonEnabled: AnyPublisher<Bool, Never> {
        return _isDuplicationCheckButtonEnabled.eraseToAnyPublisher()
    }
    
    var message: AnyPublisher<String?, Never> {
        return _message.eraseToAnyPublisher()
    }
    
    
    var messageStatus: AnyPublisher<NicknameMessageStatus, Never> {
        return _messageStatus.eraseToAnyPublisher()
    }
    
    
    func showMessageForExceedingMaxCount() {
        _message.send("8글자 이상은 입력되지 않습니다.")
        _messageStatus.send(.numberOfCharError)
    }
}
