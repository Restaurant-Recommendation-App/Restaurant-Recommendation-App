//
//  UserUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation
import Combine

protocol UserUseCase {
    func getAvatar(id: Int?) -> AnyPublisher<AvatarInfoResponse, DataTransferError>
    func getAvatarFollow() -> AnyPublisher<FollowResponse, DataTransferError>
    func postAvatarFollow(avatarId: Int) -> AnyPublisher<FollowResponse, DataTransferError>
    func deleteAvatarFollow(avatarId: Int) -> AnyPublisher<FollowResponse, DataTransferError>
    func getRecommendAvatars() -> AnyPublisher<[RecommendFollowResponse], DataTransferError>
    func postRegisterUserProfile() -> AnyPublisher<[String], DataTransferError>
}


final class DefaultUserUseCase: UserUseCase {
    private let repository: UserRepository
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func getAvatar(id: Int?) -> AnyPublisher<AvatarInfoResponse, DataTransferError> {
        return repository.getAvatar(id: id)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func getAvatarFollow() -> AnyPublisher<FollowResponse, DataTransferError> {
        return repository.getAvatarFollow()
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func postAvatarFollow(avatarId: Int) -> AnyPublisher<FollowResponse, DataTransferError> {
        return repository.postAvatarFollow(avatarId: avatarId)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func deleteAvatarFollow(avatarId: Int) -> AnyPublisher<FollowResponse, DataTransferError> {
        return repository.deleteAvatarFollow(avatarId: avatarId)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func getRecommendAvatars() -> AnyPublisher<[RecommendFollowResponse], DataTransferError> {
        return repository.getRecommendAvatars()
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func postRegisterUserProfile() -> AnyPublisher<[String], DataTransferError> {
        return repository.postRegisterUserProfile()
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
}
