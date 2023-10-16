//
//  FollowSelectionViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation
import Combine


protocol FollowSelectionViewModelTypeInput {
    func requestGetRecommendAvatars()
    func requestPostAvatarFollow(avatarId: Int)
    func requestDeleteAvatarFollow(avatarId: Int)
    func reuqestGetAvatarFollow()
    func requestPostRegisterUserProfile()
}

protocol FollowSelectionViewModelTypeOutput {
    var recommendAvatars: AnyPublisher<[RecommendFollowResponse], DataTransferError> { get }
    var addAvatarFollow: AnyPublisher<FollowResponse?, DataTransferError> { get }
    var removeAvatarFollow: AnyPublisher<FollowResponse?, DataTransferError> { get }
    var registerUserProfile: AnyPublisher<[String], DataTransferError> { get }
}


protocol FollowSelectionViewModelType {
    var input: FollowSelectionViewModelTypeInput { get }
    var output: FollowSelectionViewModelTypeOutput { get }
}

class FollowSelectionViewModel: FollowSelectionViewModelType {
    var input: FollowSelectionViewModelTypeInput { return self }
    var output: FollowSelectionViewModelTypeOutput { return self }
    
    private var cancellables: Set<AnyCancellable> = []
    private var getRecommendAvatarsSubject = PassthroughSubject<Void, Never>()
    private var postAvatarFollowSubject = PassthroughSubject<Int, Never>()
    private var deleteAvatarFollowSubject = PassthroughSubject<Int, Never>()
    private var getAvatarFollowSubject = PassthroughSubject<Void, Never>()
    private var postRegisterUserProfileSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    private let useCase: UserUseCase
    init(useCase: UserUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Private
    private func getRecommendAvatars() -> AnyPublisher<[RecommendFollowResponse], DataTransferError> {
        let subject = PassthroughSubject<[RecommendFollowResponse], DataTransferError>()
        useCase.getRecommendAvatars()
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { results in
                subject.send(results)
            }
            .store(in: &cancellables)

        return subject.eraseToAnyPublisher()
    }
    
    private func postAvatarFollow(avatarId: Int) -> AnyPublisher<FollowResponse?, DataTransferError> {
        let subject = PassthroughSubject<FollowResponse?, DataTransferError>()
        useCase.postAvatarFollow(avatarId: avatarId)
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { results in
                subject.send(results)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
    
    private func deleteAvatarFollow(avatarId: Int) -> AnyPublisher<FollowResponse?, DataTransferError> {
        let subject = PassthroughSubject<FollowResponse?, DataTransferError>()
        useCase.deleteAvatarFollow(avatarId: avatarId)
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { results in
                subject.send(results)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
    
    private func postRegisterProfile() -> AnyPublisher<[String], DataTransferError> {
        let subject = PassthroughSubject<[String], DataTransferError>()
        useCase.postRegisterUserProfile()
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { results in
                subject.send(results)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Input
extension FollowSelectionViewModel: FollowSelectionViewModelTypeInput {
    func requestGetRecommendAvatars() {
        getRecommendAvatarsSubject.send(())
    }
    
    func requestPostAvatarFollow(avatarId: Int) {
        postAvatarFollowSubject.send(avatarId)
    }
    
    func requestDeleteAvatarFollow(avatarId: Int) {
        deleteAvatarFollowSubject.send(avatarId)
    }
    
    func reuqestGetAvatarFollow() {
        getAvatarFollowSubject.send(())
    }
    
    func requestPostRegisterUserProfile() {
        postRegisterUserProfileSubject.send(())
    }
}

// MARK: - Output
extension FollowSelectionViewModel: FollowSelectionViewModelTypeOutput {
    var recommendAvatars: AnyPublisher<[RecommendFollowResponse], DataTransferError> {
        return getRecommendAvatarsSubject
            .flatMap { [weak self] type -> AnyPublisher<[RecommendFollowResponse], DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success([]))
                    }.eraseToAnyPublisher()
                }
                
                return self.getRecommendAvatars()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var addAvatarFollow: AnyPublisher<FollowResponse?, DataTransferError> {
        return postAvatarFollowSubject
            .flatMap { [weak self] avataId -> AnyPublisher<FollowResponse?, DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success(nil))
                    }.eraseToAnyPublisher()
                }
                
                return self.postAvatarFollow(avatarId: avataId)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var removeAvatarFollow: AnyPublisher<FollowResponse?, DataTransferError> {
        return deleteAvatarFollowSubject
            .flatMap { [weak self] avataId -> AnyPublisher<FollowResponse?, DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success(nil))
                    }.eraseToAnyPublisher()
                }
                
                return self.deleteAvatarFollow(avatarId: avataId)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var registerUserProfile: AnyPublisher<[String], DataTransferError> {
        return postRegisterUserProfileSubject
            .flatMap { [weak self] _ -> AnyPublisher<[String], DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success([]))
                    }.eraseToAnyPublisher()
                }
                
                return self.postRegisterProfile()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
