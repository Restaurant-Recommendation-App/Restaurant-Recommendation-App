//
//  LoginAPIEndpoints.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/8/23.
//

import Foundation

struct LoginAPIEndpoints {
    static func postOauthKakaoLogin(idToken: String) -> Endpoint<Results<UserDTO>> {
        return Endpoint(path: "api/v1/oauth/login/kakao",
                        method: .post,
                        bodyParameters: ["token":idToken,
                                         "platform": "IOS"])
    }
}
