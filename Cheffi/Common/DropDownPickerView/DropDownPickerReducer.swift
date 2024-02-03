//
//  DropDownPickerReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/28/24.
//

import Foundation
import ComposableArchitecture

struct DropDownPickerReducer: Reducer {
    struct State: Equatable {
        let placeHolder: String
        var selection: String?
        let dropDownPickerState: DropDownPickerState
        var options: [String]
        var isShowDropdown = false
        
        init(
            placeHolder: String, 
            selection: String?,
            dropDownPickerState: DropDownPickerState = .bottom,
            options: [String],
            isShowDropdown: Bool = false
        ) {
            self.placeHolder = placeHolder
            self.selection = selection
            self.dropDownPickerState = dropDownPickerState
            self.options = options
            self.isShowDropdown = isShowDropdown
        }
    }

    enum Action {
        case toggleDropDown
        case select(String)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .toggleDropDown:
            state.isShowDropdown.toggle()
            return .none
        case .select(let option):
            state.selection = option
            state.isShowDropdown.toggle()
            return .none
        }
    }
}
