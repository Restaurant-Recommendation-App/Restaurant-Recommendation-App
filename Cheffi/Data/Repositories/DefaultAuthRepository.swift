//
//  DefaultAuthRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/8/23.
//

import Foundation
import Combine

final class DefaultAuthRepository {
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

extension DefaultAuthRepository: AuthRepository {
    func postOauthKakaoLogin(idToken: String) -> AnyPublisher<(Results<UserDTO>, HTTPURLResponse), DataTransferError> {
        let endpoint = AuthAPIEndpoints.postOauthKakaoLogin(idToken: idToken)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
            .eraseToAnyPublisher()
    }
    
    func patchTerms(adAgreed: Bool) -> AnyPublisher<(Results<UserDTO>, HTTPURLResponse), DataTransferError> {
        let endpoint = AuthAPIEndpoints.patchTerms(adAgreed: adAgreed)
        return dataTransferService.request(with: endpoint, on: backgroundQueue).eraseToAnyPublisher()
    }
    
    func getNicknameInuse(nickname: String) -> AnyPublisher<(Results<Bool>, HTTPURLResponse), DataTransferError> {
        let endpoint = AuthAPIEndpoints.getNicknameInuse(nickname: nickname)
        return dataTransferService.request(with: endpoint, on: backgroundQueue).eraseToAnyPublisher()
    }
    
    func patchNickname(nickname: String) -> AnyPublisher<(Results<String>, HTTPURLResponse), DataTransferError> {
        let endpoint = AuthAPIEndpoints.patchNickname(nickname: nickname)
        return dataTransferService.request(with: endpoint, on: backgroundQueue).eraseToAnyPublisher()
    }
}
