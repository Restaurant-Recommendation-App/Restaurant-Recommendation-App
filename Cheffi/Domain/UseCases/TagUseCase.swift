//
//  TagUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation
import Combine

protocol TagUseCase {
    func getTags(type: TagType) -> AnyPublisher<[Tag], DataTransferError>
    func putTags(tagRequest: TagsChangeRequest) -> AnyPublisher<TagsChangeResponse, DataTransferError>
}

final class DefaultTagUseCase: TagUseCase {
    private let repository: TagRepository
    init(repository: TagRepository) {
        self.repository = repository
    }
    
    func getTags(type: TagType) -> AnyPublisher<[Tag], DataTransferError> {
        return repository.getTags(type: type)
            .map { $0.0.data.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    func putTags(tagRequest: TagsChangeRequest) -> AnyPublisher<TagsChangeResponse, DataTransferError> {
        return repository.putTags(tagRequest: tagRequest)
            .map { $0.0.data }
            .eraseToAnyPublisher()
    }
}
