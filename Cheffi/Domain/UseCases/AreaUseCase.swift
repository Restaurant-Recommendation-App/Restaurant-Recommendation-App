//
//  AreaUseCase.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/23.
//

import Foundation
import Combine

protocol AreaUseCase {
    func getAreas() -> AnyPublisher<[Area], Never>
}

final class DefaultAreaUseCase: AreaUseCase {
    
    let repository: AreaRepository
    
    init(repository: AreaRepository) {
        self.repository = repository
    }
    
    func getAreas() -> AnyPublisher<[Area], Never> {
        return repository.getAreas()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}