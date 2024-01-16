//
//  RestaurantRegistComposeReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import Foundation
import Combine
import ComposableArchitecture

struct RestaurantRegistComposeReducer: Reducer {
    let steps: PassthroughSubject<RouteStep, Never>

    init(
        steps: PassthroughSubject<RouteStep, Never>
    ) {
        self.steps = steps
    }
    
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
    }
}

extension RestaurantRegistComposeReducer: Stepper {}
