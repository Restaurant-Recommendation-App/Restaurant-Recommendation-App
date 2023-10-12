//
//  DefaultLoginRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/8/23.
//

import Foundation
import Combine

final class DefaultLoginRepository {
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

extension DefaultLoginRepository: LoginRepository {
    func postOauthKakaoLogin(idToken: String) -> AnyPublisher<(Results<UserDTO>, HTTPURLResponse), DataTransferError> {
        let endpoint = LoginAPIEndpoints.postOauthKakaoLogin(idToken: idToken)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
            .eraseToAnyPublisher()
    }
}
