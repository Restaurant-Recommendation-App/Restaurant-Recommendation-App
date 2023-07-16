//
//  SimilarChefRepository.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

protocol SimilarChefRepository {
    func getCategories() -> AnyPublisher<[String], Error>
    func getProfiles(category: String) -> AnyPublisher<[User], Error>
}
