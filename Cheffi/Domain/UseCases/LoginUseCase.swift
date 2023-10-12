//
//  LoginUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/8/23.
//

import Foundation
import Combine

protocol LoginUseCase {
    func execute(idToken: String) -> AnyPublisher<(User, HTTPURLResponse), DataTransferError>
}

final class DefaultLoginUserCase: LoginUseCase {
    private let repository: LoginRepository
    init(repository: LoginRepository) {
        self.repository = repository
    }
    
    func execute(idToken: String) -> AnyPublisher<(User, HTTPURLResponse), DataTransferError> {
        return repository.postOauthKakaoLogin(idToken: idToken)
            .map { ($0.0.data.toDomain(), $0.1) }
            .eraseToAnyPublisher()
    }
}
