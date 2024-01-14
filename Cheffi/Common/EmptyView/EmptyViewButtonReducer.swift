//
//  EmptyViewButtonReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/7/24.
//

import Foundation
import ComposableArchitecture

struct EmptyViewButtonReducer: Reducer {
    struct State: Equatable {
        var title: String
    }
    
    enum Action {
        case tapButton
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
