//
//  SimilarChefRepository.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

protocol SimilarChefRepository {
    func getTags(type: TagTypeRequest) -> AnyPublisher<(Results<[TagDTO]>, HTTPURLResponse), DataTransferError>
    func getUsers(tags: [String]) -> AnyPublisher<([UserDTO], HTTPURLResponse), DataTransferError>
}
