//
//  UserAPIEndpoints.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation

struct UserAPIEndpoints {
    static func getAvatar(id: Int? = nil) -> Endpoint<Results<AvatarInfoResponse>> {
        let headerParameters = (id == nil) ? [:] : ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""]
        let queryParameters = (id == nil) ? [:] : ["id": id!]
        return Endpoint(path: "api/v1/avatars",
                        method: .get,
                        headerParameters: headerParameters,
                        queryParameters: queryParameters)
    }
    
    // 자신의 팔로우 목록 조회
    static func getAvatarFollow() -> Endpoint<Results<FollowResponse>> {
        return Endpoint(path: "api/v1/avatars/follow",
                        method: .get,
                        headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""])
    }
    
    // 아바타 팔로우 등록
    static func postAvatarFollow(avatarId: Int) -> Endpoint<Results<FollowResponse>> {
        return Endpoint(path: "api/v1/avatars/follow",
                        method: .post,
                        headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""],
                        queryParameters: ["avatarId": avatarId])
    }
    
    // 아바타 팔로우 삭제
    static func deleteAvatarFollow(avatarId: Int) -> Endpoint<Results<FollowResponse>> {
        return Endpoint(path: "api/v1/avatars/follow",
                        method: .delete,
                        headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""],
                        queryParameters: ["avatarId": avatarId])
    }
    
    // 팔로우 추천 목록 조회
    static func getRecommendAvatars() -> Endpoint<Results<[RecommendFollowResponse]>> {
        return Endpoint(path: "api/v1/avatars/follow/recommend",
                        method: .get,
                        headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""])
    }
    
    // 프로필 완료 등록
    static func postRegisterUserProfile() -> Endpoint<Results<[String]>> {
        return Endpoint(path: "api/v1/users/profile",
                        method: .post,
                        headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""])
    }
}
