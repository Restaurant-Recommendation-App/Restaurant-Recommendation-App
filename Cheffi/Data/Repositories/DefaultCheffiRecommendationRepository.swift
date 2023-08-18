//
//  DefaultCheffiRecommendationRepository.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/18.
//

import Foundation
import Combine

class DefaultCheffiRecommendationRepository {
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

extension DefaultCheffiRecommendationRepository: CheffiRecommendationRepository {
    func getTags() -> AnyPublisher<[String], Never> {
        // TODO: 서비스 객채 사용
        Just(["한식", "양식", "중식", "일식", "퓨전", "샐러드"]).eraseToAnyPublisher()
    }
}
