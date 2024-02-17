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
    func registRestaurant(restaurant: RestaurantInfoDTO) -> AnyPublisher<Int, DataTransferError>
}


final class DefaultRestaurantUseCase: RestaurantUseCase {
    private let repository: RestaurantRepository
    init(repository: RestaurantRepository) {
        self.repository = repository
    }
    
    func getRestaurants(name: String, province: String, city: String) -> AnyPublisher<[RestaurantInfoDTO], DataTransferError> {
        // TODO: - Eli : 맛집등록 검색화면 API 반영
//        repository.getRestaurants(name: name, province: province, city: city)
//            .map({ $0.0.data })
//            .eraseToAnyPublisher()
        Future { promise in
            promise(.success([
                RestaurantInfoDTO(
                    id: 0,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 1,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 2,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 3,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 4,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 5,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 6,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 7,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
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
    
    func registRestaurant(restaurant: RestaurantInfoDTO) -> AnyPublisher<Int, DataTransferError> {
        // TODO: - Eli : 맛집등록 API 반영
//        repository.registRestaurant(restaurant: restaurant)
//            .map(\.0.data)
//            .eraseToAnyPublisher()
        Future { promise in
            promise(.success(1))
        }
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
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 1,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 2,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 3,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 4,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 5,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 6,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                ),
                RestaurantInfoDTO(
                    id: 7,
                    name: name,
                    address: Address(
                        province: "서울",
                        city: "강북구",
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
    
    func registRestaurant(restaurant: RestaurantInfoDTO) -> AnyPublisher<Int, DataTransferError> {
        Future { promise in
            promise(.success(1))
        }
        .eraseToAnyPublisher()
    }
}
