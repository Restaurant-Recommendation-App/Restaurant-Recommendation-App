//
//  CheffRecommendationUseCase.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/16.
//

import Foundation
import Combine

protocol CheffiRecommendationUseCase {
    func getTags() -> AnyPublisher<[String], Never>
    func getContents(reviewsByAreaRequest: ReviewsByAreaRequest) -> AnyPublisher<[Content], DataTransferError>
}

final class DefaultCheffiRecommendationUseCase: CheffiRecommendationUseCase {
    
    let cheffiRecommendationRepository: CheffiRecommendationRepository
    
    init(repository: CheffiRecommendationRepository) {
        self.cheffiRecommendationRepository = repository
    }
    
    func getTags() -> AnyPublisher<[String], Never> {
        cheffiRecommendationRepository.getTags()
    }
    
    func getContents(reviewsByAreaRequest: ReviewsByAreaRequest) -> AnyPublisher<[Content], DataTransferError> {
        cheffiRecommendationRepository.getContents(reviewsByAreaRequest: reviewsByAreaRequest)
            .map { $0.0.data.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
}
