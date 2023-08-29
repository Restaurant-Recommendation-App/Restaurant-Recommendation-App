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
    func getContents(with tag: String, page: Int) -> AnyPublisher<[Content], Never>
}

final class DefaultCheffiRecommendationUseCase: CheffiRecommendationUseCase {
    
    let cheffiRecommendationRepository: CheffiRecommendationRepository
    
    init(repository: CheffiRecommendationRepository) {
        self.cheffiRecommendationRepository = repository
    }
    
    func getTags() -> AnyPublisher<[String], Never> {
        cheffiRecommendationRepository.getTags()
    }
    
    func getContents(with tag: String, page: Int) -> AnyPublisher<[Content], Never> {
        cheffiRecommendationRepository.getContents(with: tag, page: page)
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
}
