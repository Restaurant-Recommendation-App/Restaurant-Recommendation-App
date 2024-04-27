//
//  TagUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation
import Combine

protocol TagUseCase {
    func getTags(type: TagTypeRequest) -> AnyPublisher<[Tag], DataTransferError>
    func putTags(tagRequest: TestTagsChangeRequest) -> AnyPublisher<TagsChangeResponse, DataTransferError>
    func postRegisterUserProfile() -> AnyPublisher<[String], DataTransferError>
}

final class DefaultTagUseCase: TagUseCase {
    private let tagRepository: TagRepository
    private let userRepository: UserRepository
    
    init(tagRepository: TagRepository, userRepository: UserRepository) {
        self.tagRepository = tagRepository
        self.userRepository = userRepository
    }
    
    func getTags(type: TagTypeRequest) -> AnyPublisher<[Tag], DataTransferError> {
        return tagRepository.getTags(type: type)
            .map { $0.0.data.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    func putTags(tagRequest: TestTagsChangeRequest) -> AnyPublisher<TagsChangeResponse, DataTransferError> {
        return tagRepository.putTags(tagRequest: tagRequest)
            .map { $0.0.data }
            .eraseToAnyPublisher()
    }
    
    func postRegisterUserProfile() -> AnyPublisher<[String], DataTransferError> {
        return userRepository.postRegisterUserProfile()
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
}
