//
//  TextEditorViewReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 2/19/24.
//

import Foundation
import ComposableArchitecture

struct TextEditorViewReducer: Reducer {
    struct State: Equatable {
        var txt: String
        let placeHolder: String
        let minCount: Int?
        
        init(
            txt: String = "",
            placeHolder: String,
            minCount: Int? = nil
        ) {
            self.txt = txt
            self.placeHolder = placeHolder
            self.minCount = minCount
        }
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
