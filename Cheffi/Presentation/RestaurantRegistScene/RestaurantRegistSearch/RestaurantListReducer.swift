//
//  RestaurantListReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/9/24.
//

import Foundation
import ComposableArchitecture

struct RestaurantListReducer: Reducer {
    struct State: Equatable {
        var restaurantList: [RestaurantInfoDTO] = []
        var highlightKeyword: String = ""
    }
    
    enum Action {
        case tap(item: RestaurantInfoDTO)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
