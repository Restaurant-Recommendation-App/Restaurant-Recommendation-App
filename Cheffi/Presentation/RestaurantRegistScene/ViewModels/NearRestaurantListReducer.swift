//
//  NearRestaurantListReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/6/24.
//

import Foundation
import ComposableArchitecture

struct NearRestaurantListReducer: Reducer {
    struct State: Equatable {
        var nearRestaurantList: [RestaurantInfoDTO] = []
    }
    
    enum Action {}
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {}
}
