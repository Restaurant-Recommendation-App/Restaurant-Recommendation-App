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
    func registRestaurant(restaurant: RestaurantRegistRequest) -> AnyPublisher<Int, DataTransferError>
    func getAreas() -> AnyPublisher<[Area], DataTransferError>
}


final class DefaultRestaurantUseCase: RestaurantUseCase {
    private let restaurantRepository: RestaurantRepository
    private let areaRepository: AreaRepository
    init(
        restaurantRepository: RestaurantRepository,
        areaRepository: AreaRepository
    ) {
        self.restaurantRepository = restaurantRepository
        self.areaRepository = areaRepository
    }
    
    func getRestaurants(name: String, province: String, city: String) -> AnyPublisher<[RestaurantInfoDTO], DataTransferError> {
        restaurantRepository.getRestaurants(name: name, province: province, city: city)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func registRestaurant(restaurant: RestaurantRegistRequest) -> AnyPublisher<Int, DataTransferError> {
        restaurantRepository.registRestaurant(restaurant: restaurant)
            .map(\.0.data)
            .eraseToAnyPublisher()
    }
    
    func getAreas() -> AnyPublisher<[Area], DataTransferError> {
        return areaRepository.getAreas()
            .map { $0.0.data.map { $0.toDomain() } }
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
    
    func registRestaurant(restaurant: RestaurantRegistRequest) -> AnyPublisher<Int, DataTransferError> {
        Future { promise in
            promise(.success(1))
        }
        .eraseToAnyPublisher()
    }
    
    func getAreas() -> AnyPublisher<[Area], DataTransferError> {
        Future { promise in
            promise(.success([
                Area(province: "서울특별시", cities: ["강남구", "강동구", "강북구"]),
                Area(province: "인천광역시", cities: ["강남구", "강동구", "강북구"]),
                Area(province: "부산광역시", cities: ["강남구", "강동구", "강북구"]),
                Area(province: "서울특별시2", cities: ["강남구", "강동구", "강북구"]),
                Area(province: "인천광역시2", cities: ["강남구", "강동구", "강북구"]),
                Area(province: "부산광역시2", cities: ["강남구", "강동구", "강북구"]),
                Area(province: "서울특별시3", cities: ["강남구", "강동구", "강북구"]),
                Area(province: "인천광역시3", cities: ["강남구", "강동구", "강북구"]),
                Area(province: "부산광역시3", cities: ["강남구", "강동구", "강북구"])
            ]))
        }
        .eraseToAnyPublisher()
    }
}
