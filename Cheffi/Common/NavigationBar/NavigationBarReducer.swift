//
//  NavigationBarReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/21/24.
//

import Foundation
import ComposableArchitecture

struct NavigationBarReducer: Reducer {
    enum ButtonKind: String {
        case close = "icClose"
        case back = "icBack"
    }
    
    struct State: Equatable {
        let title: String
        let buttonKind: ButtonKind
    }
    
    enum Action {
        case tap
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
