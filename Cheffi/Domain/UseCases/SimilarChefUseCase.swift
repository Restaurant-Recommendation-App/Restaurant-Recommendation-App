//
//  SimilarChefUseCase.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

protocol SimilarChefUseCase {
    func getTags(type: TagTypeRequest) -> AnyPublisher<[Tag], DataTransferError>
    func getUsers(tags: [String]) -> AnyPublisher<[User], DataTransferError>
}

final class DefaultSimilarChefUseCase: SimilarChefUseCase {
    private let repository: SimilarChefRepository
    
    init(repository: SimilarChefRepository) {
        self.repository = repository
    }
    
    func getTags(type: TagTypeRequest) -> AnyPublisher<[Tag], DataTransferError> {
        return repository.getTags(type: type)
            .map { $0.0.data.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    func getUsers(tags: [String]) -> AnyPublisher<[User], DataTransferError> {
        return repository.getUsers(tags: tags)
            .map { $0.0.map { $0.toDomain() } } // UserInfoDTO를 User로 변환
            .eraseToAnyPublisher()
    }
}
