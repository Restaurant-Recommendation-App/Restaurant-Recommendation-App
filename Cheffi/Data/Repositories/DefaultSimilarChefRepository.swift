//
//  DefaultSimilarChefRepository.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

class DefaultSimilarChefRepository: SimilarChefRepository {
    func getCategories() -> AnyPublisher<[String], Error> {
        let exampleCategories = ["한식", "노포", "아시아음식", "매운맛", "친절함"]
        return Just(exampleCategories)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getProfiles(categories: [String]) -> AnyPublisher<[User], Error> {
        let exampleProfiles = (1...12).map({ User(id: "\($0)", name: "김맛집\($0)")})
        
        return Just(exampleProfiles)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
