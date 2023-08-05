//
//  SimilarChefRepository.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

protocol SimilarChefRepository {
    func getCheffiTags() -> AnyPublisher<[CheffiTagResponseDTO], DataTransferError>
    func getProfiles(tags: [String]) -> AnyPublisher<[UserResponseDTO], DataTransferError>
}
