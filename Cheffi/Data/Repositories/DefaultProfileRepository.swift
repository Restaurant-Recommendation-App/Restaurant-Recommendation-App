//
//  DefaultProfileRepository.swift
//  Cheffi
//
//  Created by 김문옥 on 5/6/24.
//

import Foundation
import Combine

final class DefaultProfileRepository {
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

extension DefaultProfileRepository: ProfileRepository {
    func getProfile(id: Int?) -> AnyPublisher<(Results<ProfileDTO>, HTTPURLResponse), DataTransferError> {
        let endpoint = ProfileAPIEndpoints.getProfile(id: id)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
}
