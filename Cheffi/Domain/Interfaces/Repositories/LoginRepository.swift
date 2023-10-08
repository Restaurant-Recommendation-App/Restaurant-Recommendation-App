//
//  LoginRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/8/23.
//

import Foundation
import Combine

protocol LoginRepository {
    func postOauthKakaoLogin(idToken: String) -> AnyPublisher<(Results<UserDTO>, HTTPURLResponse), DataTransferError>
}
