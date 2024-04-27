//
//  DefaultTagRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation
import Combine

final class DefaultTagRepository {
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultTagRepository: TagRepository {
    func getTags(type: TagTypeRequest) -> AnyPublisher<(Results<[TagDTO]>, HTTPURLResponse), DataTransferError> {
        let endpoint = TagAPIEndpoints.getTags(type: type)
        return dataTransferService.request(with: endpoint, on: backgroundQueue).eraseToAnyPublisher()
    }
    
    func putTags(tagRequest: TestTagsChangeRequest) -> AnyPublisher<(Results<TagsChangeResponse>, HTTPURLResponse), DataTransferError> {
        let endpoint = TagAPIEndpoints.putTags(tagRequest: tagRequest)
        return dataTransferService.request(with: endpoint, on: backgroundQueue).eraseToAnyPublisher()
    }
}
