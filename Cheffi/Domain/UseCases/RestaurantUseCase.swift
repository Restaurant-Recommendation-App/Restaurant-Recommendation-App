//
//  RestaurantUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/22/23.
//

import Foundation
import Combine

protocol RestaurantUseCase {
    func getRestaurants(name: String, province: String, city: String) -> AnyPublisher<[RestaurantInfoDTO], DataTransferError>
}


final class DefaultRestaurantUseCase: RestaurantUseCase {
    private let repository: RestaurantRepository
    init(repository: RestaurantRepository) {
        self.repository = repository
    }
    
    func getRestaurants(name: String, province: String, city: String) -> AnyPublisher<[RestaurantInfoDTO], DataTransferError> {
        return repository.getRestaurants(name: name, province: province, city: city)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
}

final class PreviewRestaurantRegistUseCase: RestaurantUseCase {
    func getRestaurants(name: String, province: String, city: String) -> AnyPublisher<[RestaurantInfoDTO], DataTransferError> {
        Future { promise in
            promise(.success([
                RestaurantInfoDTO(
                    id: 0, 
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        lotNumber: "수유3동",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                )
            ]))
        }
        .eraseToAnyPublisher()
    }
}
