//
//  AuthUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/8/23.
//

import Foundation
import Combine

protocol AuthUseCase {
    func postOauthKakaoLoing(idToken: String) -> AnyPublisher<(User, HTTPURLResponse), DataTransferError>
    func patchTerms(adAgreed: Bool) -> AnyPublisher<(User, HTTPURLResponse), DataTransferError>
    func getNicknameInuse(nickname: String) -> AnyPublisher<(Bool, HTTPURLResponse), DataTransferError>
    func patchNickname(nickname: String) -> AnyPublisher<(String, HTTPURLResponse), DataTransferError>
}

final class DefaultAuthUserCase: AuthUseCase {
    private let repository: AuthRepository
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func postOauthKakaoLoing(idToken: String) -> AnyPublisher<(User, HTTPURLResponse), DataTransferError> {
        return repository.postOauthKakaoLogin(idToken: idToken)
            .map { ($0.0.data.toDomain(), $0.1) }
            .eraseToAnyPublisher()
    }
    
    func patchTerms(adAgreed: Bool) -> AnyPublisher<(User, HTTPURLResponse), DataTransferError> {
        return repository.patchTerms(adAgreed: adAgreed)
            .map { ($0.0.data.toDomain(), $0.1) }
            .eraseToAnyPublisher()
    }
    
    func getNicknameInuse(nickname: String) -> AnyPublisher<(Bool, HTTPURLResponse), DataTransferError> {
        return repository.getNicknameInuse(nickname: nickname)
            .map { ($0.0.data, $0.1) }
            .eraseToAnyPublisher()
    }
    
    func patchNickname(nickname: String) -> AnyPublisher<(String, HTTPURLResponse), DataTransferError> {
        return repository.patchNickname(nickname: nickname)
            .map { ($0.0.data, $0.1) }
            .eraseToAnyPublisher()
    }
}
