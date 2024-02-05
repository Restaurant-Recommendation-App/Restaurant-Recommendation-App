//
//  CheffiRecommendationRepository.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/17.
//

import Combine
import Foundation

protocol CheffiRecommendationRepository {
    func getTags() -> AnyPublisher<[String], Never>
    func getContents(reviewsByAreaRequest: ReviewsByAreaRequest) -> AnyPublisher<(PaginationResults<[ContentsResponseDTO]>, HTTPURLResponse), DataTransferError>
}
