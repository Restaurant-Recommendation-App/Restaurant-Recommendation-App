//
//  EmptyDescriptionViewReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/7/24.
//

import Foundation
import ComposableArchitecture

struct EmptyDescriptionViewReducer: Reducer {
    struct State: Equatable {
        var imageName: String
        var descriptionText: String
        
        var emptyViewButtonState: EmptyViewButtonReducer.State
    }
    enum Action {
        case emptyViewButtonAction(EmptyViewButtonReducer.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
