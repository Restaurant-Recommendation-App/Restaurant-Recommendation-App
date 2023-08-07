//
//  DefaultSimilarChefRepository.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

final class DefaultSimilarChefRepository {
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

extension DefaultSimilarChefRepository: SimilarChefRepository {
    
    func getTags() -> AnyPublisher<[TagResponseDTO], DataTransferError> {
        let endpoint = HomeAPIEndpoints.getTags()
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
            .eraseToAnyPublisher()
    }
    
    func getUsers(tags: [String]) -> AnyPublisher<[UserInfoDTO], DataTransferError> {
        let endpoint = HomeAPIEndpoints.getUsers(tags: tags)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
            .eraseToAnyPublisher()
    }
}
