//
//  SearchUseCase.swift
//  Cheffi
//
//  Created by RONICK on 2023/12/27.
//

import Foundation
import Combine

protocol SearchUseCase {
    func getRecentSearch(withCategory category: SearchCategory) -> AnyPublisher<[String], Never>
}

final class DefaultSearchUseCase: SearchUseCase {
    
    let repository: SearchRepository
    
    init(repository: SearchRepository) {
        self.repository = repository
    }
    
    func getRecentSearch(withCategory category: SearchCategory) -> AnyPublisher<[String], Never> {
        return repository.getRecentSearch(withCategory: category)
            .eraseToAnyPublisher()
    }
}
