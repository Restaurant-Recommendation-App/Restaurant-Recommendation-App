//
//  BottomButtonReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/27/24.
//

import Foundation
import ComposableArchitecture

struct BottomButtonReducer: Reducer {
    struct State: Equatable {
        let title: String
        var able: Bool
    }
    
    enum Action {
        case tap
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
