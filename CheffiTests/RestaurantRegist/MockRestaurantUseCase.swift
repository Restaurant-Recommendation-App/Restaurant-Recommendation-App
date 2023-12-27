//
//  MockRestaurantUseCase.swift
//  CheffiTests
//
//  Created by Eli_01 on 12/24/23.
//

import XCTest
import Combine
@testable import Cheffi

final class MockRestaurantUseCase: RestaurantUseCase {
    var restaurants: Result<[Cheffi.RestaurantInfoDTO], Cheffi.DataTransferError>!

    func getRestaurants(name: String, province: String, city: String) -> AnyPublisher<[Cheffi.RestaurantInfoDTO], Cheffi.DataTransferError> {
        Future { promise in
            promise(self.restaurants)
        }
        .eraseToAnyPublisher()
    }
}
