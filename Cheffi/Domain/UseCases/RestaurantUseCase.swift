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
    private let respository: RestaurantRepository
    init(respository: RestaurantRepository) {
        self.respository = respository
    }
    
    func getRestaurants(name: String, province: String, city: String) -> AnyPublisher<[RestaurantInfoDTO], DataTransferError> {
        return respository.getRestaurants(name: name, province: province, city: city)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
}
