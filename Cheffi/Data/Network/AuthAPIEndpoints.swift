//
//  AuthAPIEndpoints.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/8/23.
//

import Foundation

struct AuthAPIEndpoints {
    static func postOauthKakaoLogin(idToken: String) -> Endpoint<Results<UserDTO>> {
        return Endpoint(path: "api/v1/oauth/login/kakao",
                        method: .post,
                        bodyParameters: ["token":idToken,
                                         "platform": "IOS"])
    }
    
    static func patchTerms(adAgreed: Bool, analysisAgreed: Bool) -> Endpoint<Results<UserDTO>> {
        return Endpoint(path: "api/v1/users/terms",
                        method: .patch,
                        headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""],
                        bodyParameters: ["ad_agreed": adAgreed,
                                         "analysis_agreed": analysisAgreed])
    }
    
    static func getNicknameInuse(nickname: String) -> Endpoint<Results<Bool>> {
        return Endpoint(path: "api/v1/avatars/nickname/inuse",
                        method: .get,
                        queryParameters: ["nickname": nickname])
    }
    
    static func patchNickname(nickname: String) -> Endpoint<Results<String>> {
        return Endpoint(path: "api/v1/avatars/nickname",
                        method: .patch,
                        headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""],
                        bodyParameters: ["nickname": nickname])
    }
    
    static func postPhosts(imageData: Data) -> Endpoint<Results<String>> {
        let boundary = "Boundary-\(UUID().uuidString)"
        return Endpoint(path: "api/v1/avatars/photos",
                        method: .post,
                        headerParameters: [
                            "Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? "",
                            "Content-Type": "multipart/form-data; boundary=\(boundary)"
                        ],
                        bodyParameters: [
                            "file": imageData,
                            "request": ["default": true]
                        ],
                        bodyEncoding: .multipartFormData,
                        bodyBoundary: boundary)
    }
}
