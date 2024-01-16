//
//  RouteStep.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import Foundation

enum RouteStep {
    case restaurantRegistSearch
    case restaurantRegistCompose
    case restaurantInfoCompose(info: RestaurantInfoDTO)
}
