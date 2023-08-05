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
    
    func getCheffiTags() -> AnyPublisher<[CheffiTagResponseDTO], DataTransferError> {
        let endpoint = HomeAPIEndpoints.getCheffiTags()
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
            .eraseToAnyPublisher()
    }
    
    func getProfiles(tags: [String]) -> AnyPublisher<[UserResponseDTO], DataTransferError> {
        let endpoint = HomeAPIEndpoints.getProfiles(tags: tags)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
            .eraseToAnyPublisher()
    }
}
