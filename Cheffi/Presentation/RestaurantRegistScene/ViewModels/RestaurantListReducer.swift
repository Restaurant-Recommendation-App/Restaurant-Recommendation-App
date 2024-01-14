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
    }
    
    enum Action {}
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {}
}
