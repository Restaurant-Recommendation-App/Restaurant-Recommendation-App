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
        var txt: String
        var textNumber: Int?
        let placeHolder: String
        let rightText: String?
        let maxCount: Int?
        let isNumberOnly: Bool
        
        init(
            txt: String = "",
            placeHolder: String,
            rightText: String? = nil,
            maxCount: Int? = nil,
            isNumberOnly: Bool = false
        ) {
            self.txt = txt
            self.placeHolder = placeHolder
            self.rightText = rightText
            self.maxCount = maxCount
            self.isNumberOnly = isNumberOnly
        }
    }

    enum Action {
        case input(String)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .input(let txt):
            state.txt = txt
            if state.isNumberOnly {
                let numberFormatter: NumberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                if let formattedNumber = numberFormatter.number(from: txt) {
                    state.textNumber = Int(truncating: formattedNumber)
                }
            }
            return .none
        }
    }
}
