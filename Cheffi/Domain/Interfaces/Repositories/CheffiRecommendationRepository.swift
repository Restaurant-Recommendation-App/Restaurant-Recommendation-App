//
//  CheffiRecommendationRepository.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/17.
//

import Combine

protocol CheffiRecommendationRepository {
    func getTags() -> AnyPublisher<[String], Never>
    func getContents(with tag: String, page: Int) -> AnyPublisher<[ContentsResponseDTO.contentDTO], Never>
}