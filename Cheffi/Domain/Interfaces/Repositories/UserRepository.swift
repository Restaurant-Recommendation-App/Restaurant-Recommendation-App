//
//  UserRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation
import Combine

protocol UserRepository {
    func getAvatar(id: Int?) -> AnyPublisher<(Results<AvatarInfoResponse>, HTTPURLResponse), DataTransferError>
    func getAvatarFollow() -> AnyPublisher<(Results<FollowResponse>, HTTPURLResponse), DataTransferError>
    func postAvatarFollow(avatarId: Int) -> AnyPublisher<(Results<FollowResponse>, HTTPURLResponse), DataTransferError>
    func deleteAvatarFollow(avatarId: Int) -> AnyPublisher<(Results<FollowResponse>, HTTPURLResponse), DataTransferError>
    func getRecommendAvatars() -> AnyPublisher<(Results<[RecommendFollowResponse]>, HTTPURLResponse), DataTransferError>
    func postRegisterUserProfile() -> AnyPublisher<(Results<[String]>, HTTPURLResponse), DataTransferError>
}
