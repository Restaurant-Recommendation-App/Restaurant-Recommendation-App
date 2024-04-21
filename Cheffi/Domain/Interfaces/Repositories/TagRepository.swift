//
//  TagRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/15/23.
//

import Foundation
import Combine

protocol TagRepository {
    func getTags(type: TagType) -> AnyPublisher<(Results<[TagDTO]>, HTTPURLResponse), DataTransferError>
    func putTags(tagRequest: TestTagsChangeRequest) -> AnyPublisher<(Results<TagsChangeResponse>, HTTPURLResponse), DataTransferError>
}
