//
//  SearchBarReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/1/24.
//

import Foundation
import ComposableArchitecture

struct SearchBarReducer: Reducer {
    struct State: Equatable {
        var searchQuery: String = ""
    }

    enum Action {
        case input(String)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .input(let txt):
            state.searchQuery = txt
            return .none
        }
    }
}
