//
//  CheffRecommendationUseCase.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/16.
//

import Foundation
import Combine

protocol CheffiRecommendationUseCase {
    func getTags() -> AnyPublisher<[Tag], DataTransferError>
    func getContentsByArea(reviewsByAreaRequest: ReviewsByAreaRequest) -> AnyPublisher<[Content], DataTransferError>
    func getContentsByTag(reviewsByTagRequest: ReviewsByTagRequest) -> AnyPublisher<[Content], DataTransferError>
}

final class DefaultCheffiRecommendationUseCase: CheffiRecommendationUseCase {
    
    let cheffiRecommendationRepository: CheffiRecommendationRepository
    
    init(repository: CheffiRecommendationRepository) {
        self.cheffiRecommendationRepository = repository
    }
    
    func getTags() -> AnyPublisher<[Tag], DataTransferError> {
        cheffiRecommendationRepository.getTags()
            .map { $0.0.data.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    func getContentsByArea(reviewsByAreaRequest: ReviewsByAreaRequest) -> AnyPublisher<[Content], DataTransferError> {
        cheffiRecommendationRepository.getContentsByArea(reviewsByAreaRequest: reviewsByAreaRequest)
            .map { $0.0.data.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    func getContentsByTag(reviewsByTagRequest: ReviewsByTagRequest) -> AnyPublisher<[Content], DataTransferError> {
        cheffiRecommendationRepository.getContentsByTag(reviewsByTagRequest: reviewsByTagRequest)
            .map { $0.0.data.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
