//
//  DefaultAreaRepository.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/23.
//

import Foundation
import Combine

final class DefaultAreaRepository {
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

extension DefaultAreaRepository: AreaRepository {
    func getAreas() -> AnyPublisher<(Results<[AreaDTO]>, HTTPURLResponse), DataTransferError> {
        let endPoint = AreaAPIEndpoints.getAreas()
        return dataTransferService.request(with: endPoint, on: backgroundQueue).eraseToAnyPublisher()
    }
}
