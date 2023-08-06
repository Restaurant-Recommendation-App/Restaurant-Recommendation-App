//
//  SimilarChefRepository.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

protocol SimilarChefRepository {
    func getTags() -> AnyPublisher<[TagResponseDTO], DataTransferError>
    func getUsers(tags: [String]) -> AnyPublisher<[UserInfoDTO], DataTransferError>
}
