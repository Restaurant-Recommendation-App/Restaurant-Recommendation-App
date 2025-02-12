//
//  ConfirmPopupReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 2/4/24.
//

import Foundation
import ComposableArchitecture

struct ConfirmPopupReducer: Reducer {
    struct State: Equatable {
        let title: String
        let description: String
        let primaryButtonTitle: String
        let secondaryButtonTitle: String?
        let optionButtonTitle: String?
        
        init(
            title: String, 
            description: String,
            primaryButtonTitle: String,
            secondaryButtonTitle: String? = nil,
            optionButtonTitle: String? = nil
        ) {
            self.title = title
            self.description = description
            self.primaryButtonTitle = primaryButtonTitle
            self.secondaryButtonTitle = secondaryButtonTitle
            self.optionButtonTitle = optionButtonTitle
        }
    }
    
    enum Action {
        case primary
        case secondary
        case option
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
