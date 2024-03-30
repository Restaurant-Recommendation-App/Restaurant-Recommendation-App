//
//  DefaultRestaurantRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/22/23.
//

import Foundation
import Combine

final class DefaultRestaurantRepository {
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

extension DefaultRestaurantRepository: RestaurantRepository {
    func getRestaurants(name: String, province: String, city: String) -> AnyPublisher<(Results<[RestaurantInfoDTO]>, HTTPURLResponse), DataTransferError> {
        let endpoint = RestaurantAPIEndpoints.getRestaurants(name: name, province: province, city: city)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
    
    func getNearRestaurants(x: String?, y: String?) -> AnyPublisher<(Results<[RestaurantInfoDTO]>, HTTPURLResponse), DataTransferError> {
        let endpoint = RestaurantAPIEndpoints.getNearRestaurants(x: x, y: y)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
    
    func registRestaurant(restaurant: RestaurantRegistRequest) -> AnyPublisher<(Results<Int>, HTTPURLResponse), DataTransferError> {
        let endpoint = RestaurantAPIEndpoints.registRestaurant(restaurant: restaurant)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
}
