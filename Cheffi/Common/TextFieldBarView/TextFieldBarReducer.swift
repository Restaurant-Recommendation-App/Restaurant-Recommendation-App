//
//  TextFieldBarReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/28/24.
//

import Foundation
import ComposableArchitecture

struct TextFieldBarReducer: Reducer {
    struct State: Equatable {
        var txt: String = ""
        let placeHolder: String
    }

    enum Action {
        case input(String)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .input(let txt):
            state.txt = txt
            return .none
        }
    }
}
