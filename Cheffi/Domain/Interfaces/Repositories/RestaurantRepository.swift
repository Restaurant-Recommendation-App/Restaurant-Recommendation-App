//
//  RestaurantRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/22/23.
//

import Foundation
import Combine

protocol RestaurantRepository {
    func getRestaurants(name: String, province: String, city: String) -> AnyPublisher<(Results<[RestaurantInfoDTO]>, HTTPURLResponse), DataTransferError>
    func getNearRestaurants(x: String?, y: String?) -> AnyPublisher<(Results<[RestaurantInfoDTO]>, HTTPURLResponse), DataTransferError>
    func registRestaurant(restaurant: RestaurantRegistRequest) -> AnyPublisher<(Results<Int>, HTTPURLResponse), DataTransferError>
}
