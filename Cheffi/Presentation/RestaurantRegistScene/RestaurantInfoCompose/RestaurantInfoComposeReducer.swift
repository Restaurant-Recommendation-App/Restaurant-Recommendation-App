//
//  RestaurantInfoComposeReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import Foundation
import Combine
import ComposableArchitecture

struct RestaurantInfoComposeReducer: Reducer {
    let steps: PassthroughSubject<RouteStep, Never>

    init(
        steps: PassthroughSubject<RouteStep, Never>
    ) {
        self.steps = steps
    }
    
    struct State: Equatable {
        var restaurant: RestaurantInfoDTO
    }
    
    enum Action {}
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {}
}

extension RestaurantInfoComposeReducer: Stepper {}
