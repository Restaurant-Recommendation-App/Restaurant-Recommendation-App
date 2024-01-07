//
//  AreaRepository.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/23.
//

import Foundation
import Combine

protocol AreaRepository {
    func getAreas() -> AnyPublisher<(Results<[AreaDTO]>, HTTPURLResponse), DataTransferError>
}
