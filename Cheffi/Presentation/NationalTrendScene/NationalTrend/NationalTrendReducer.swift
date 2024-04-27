//
//  NationalTrendReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 4/5/24.
//

import Foundation
import Combine
import ComposableArchitecture

struct NationalTrendReducer: Reducer {
    let steps: PassthroughSubject<RouteStep, Never>
    
    init(
        steps: PassthroughSubject<RouteStep, Never>
    ) {
        self.steps = steps
    }
    
    struct State: Equatable {
    }
    
    enum Action {
        case closeButtonTapped
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .closeButtonTapped:
            steps.send(.dismissNationalTrend)
            return .none
        }
    }
}

extension NationalTrendReducer: Stepper {}
