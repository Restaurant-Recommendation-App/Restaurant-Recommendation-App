//
//  NavigationBarReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/21/24.
//

import Foundation
import ComposableArchitecture

struct NavigationBarReducer: Reducer {
    enum LeftButtonKind: String {
        case close = "icClose"
        case back = "icBack"
    }
    
    struct State: Equatable {
        let title: String
        let leftButtonKind: LeftButtonKind
        var rightButtonTitle: String?
    }
    
    enum Action {
        case leftButtonTapped
        case rightButtonTapped
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
