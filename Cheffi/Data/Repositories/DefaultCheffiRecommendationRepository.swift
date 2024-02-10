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
        // TODO: 서비스 객체 사용
        Just(["한식", "양식", "중식", "일식", "퓨전", "샐러드"]).eraseToAnyPublisher()
    }
    
    func getContentsByArea(reviewsByAreaRequest: ReviewsByAreaRequest) -> AnyPublisher<(PaginationResults<[ContentsResponseDTO]>, HTTPURLResponse), DataTransferError> {
        let endPoint = ReviewAPIEndpoints.getReviewsByArea(reviewsByAreaRequest: reviewsByAreaRequest)
        return dataTransferService.request(with: endPoint, on: backgroundQueue).eraseToAnyPublisher()
    }
    
    func getContentsByTag(reviewsByTagRequest: ReviewsByTagRequest) -> AnyPublisher<(PaginationResults<[ContentsResponseDTO]>, HTTPURLResponse), DataTransferError> {
        let endPoint = ReviewAPIEndpoints.getReviewsByTag(reviewsByTagRequest: reviewsByTagRequest)
        return dataTransferService.request(with: endPoint, on: backgroundQueue).eraseToAnyPublisher()
    }
}
