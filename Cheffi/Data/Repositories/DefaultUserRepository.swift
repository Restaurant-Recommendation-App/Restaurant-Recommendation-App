//
//  DefaultUserRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation
import Combine

final class DefaultUserRepository {
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultUserRepository: UserRepository {
    func getAvatar(id: Int?) -> AnyPublisher<(Results<AvatarInfoResponse>, HTTPURLResponse), DataTransferError> {
        let endpoint = UserAPIEndpoints.getAvatar(id: id)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
    
    func getAvatarFollow() -> AnyPublisher<(Results<FollowResponse>, HTTPURLResponse), DataTransferError> {
        let endpoint = UserAPIEndpoints.getAvatarFollow()
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
    
    func postAvatarFollow(avatarId: Int) -> AnyPublisher<(Results<FollowResponse>, HTTPURLResponse), DataTransferError> {
        let endpoint = UserAPIEndpoints.postAvatarFollow(avatarId: avatarId)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
    
    func deleteAvatarFollow(avatarId: Int) -> AnyPublisher<(Results<FollowResponse>, HTTPURLResponse), DataTransferError> {
        let endpoint = UserAPIEndpoints.deleteAvatarFollow(avatarId: avatarId)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
    
    func getRecommendAvatars() -> AnyPublisher<(Results<[RecommendFollowResponse]>, HTTPURLResponse), DataTransferError> {
        let endpoint = UserAPIEndpoints.getRecommendAvatars()
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
    
    func postRegisterUserProfile() -> AnyPublisher<(Results<[String]>, HTTPURLResponse), DataTransferError> {
        let endpoint = UserAPIEndpoints.postRegisterUserProfile()
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
}
