//
//  RestaurantMenuComposePopupReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 2/25/24.
//

import Foundation
import ComposableArchitecture

struct RestaurantMenuComposePopupReducer: Reducer {
    struct State: Equatable {
        var menuNameTextFieldState = TextFieldBarReducer.State(placeHolder: "메뉴명")
        var menuPriceTextFieldState = TextFieldBarReducer.State(
            placeHolder: "가격",
            rightText: "원",
            isNumberOnly: true
        )
        var tappable: Bool = false
    }
    
    enum Action {
        case menuNameTextFieldAction(TextFieldBarReducer.Action)
        case menuPriceTextFieldAction(TextFieldBarReducer.Action)
        case setEnableNext
        case tap
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .menuNameTextFieldAction(let action):
            switch action {
            case .input(let txt):
                state.menuNameTextFieldState.txt = txt
                return .send(.setEnableNext)
            }
        case .menuPriceTextFieldAction(let action):
            switch action {
            case .input(let txt):
                state.menuPriceTextFieldState.txt = txt
                if state.menuPriceTextFieldState.isNumberOnly {
                    let numberFormatter: NumberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    if let formattedNumber = numberFormatter.number(from: txt) {
                        state.menuPriceTextFieldState.textNumber = Int(truncating: formattedNumber)
                    }
                }
                return .send(.setEnableNext)
            }
        case .setEnableNext:
            let enableNext = state.menuNameTextFieldState.txt.isEmpty == false &&
            state.menuPriceTextFieldState.txt.isEmpty == false
            state.tappable = enableNext
            return .none
        case .tap:
            return .none
        }
    }
}
