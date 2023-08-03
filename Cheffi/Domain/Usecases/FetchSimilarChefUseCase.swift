//
//  FetchSimilarChefUseCase.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

protocol FetchSimilarChefUseCase {
    func execute(categories: [String]) -> AnyPublisher<[User], Error>
}

final class DefaultFetchSimilarChefUseCase: FetchSimilarChefUseCase {
    private let repository: SimilarChefRepository
    
    init(repository: SimilarChefRepository) {
        self.repository = repository
    }
    
    func execute(categories: [String]) -> AnyPublisher<[User], Error> {
        return repository.getProfiles(categories: categories)
    }
}
