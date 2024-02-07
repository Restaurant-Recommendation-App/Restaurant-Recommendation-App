//
//  RouteStep.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import Foundation

enum RouteStep {
    case popToNavigationController
    case dismissRestaurantRegist
    case pushRestaurantRegistSearch
    case pushRestaurantRegistCompose
    case pushRestaurantInfoCompose(info: RestaurantInfoDTO)
}
