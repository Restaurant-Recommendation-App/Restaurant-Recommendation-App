//
//  FetchSimilarChefUseCase.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

protocol FetchSimilarChefUseCase {
    func execute(tags: [String]) -> AnyPublisher<[User], DataTransferError>
}

final class DefaultFetchSimilarChefUseCase: FetchSimilarChefUseCase {
    private let repository: SimilarChefRepository
    
    init(repository: SimilarChefRepository) {
        self.repository = repository
    }
    
    func execute(tags: [String]) -> AnyPublisher<[User], DataTransferError> {
        return repository.getUsers(tags: tags)
            .map { $0.map { $0.toDomain() } } // UserInfoDTO를 User로 변환
            .eraseToAnyPublisher()
    }
}
