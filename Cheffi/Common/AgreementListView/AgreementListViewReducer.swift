//
//  AgreementListViewStore.swift
//  Cheffi
//
//  Created by ronick on 2024/04/08.
//

import Foundation
import ComposableArchitecture

class AgreementListViewReducer: Reducer {
    struct State: Equatable {
        var isConsented: [Terms: Bool] = Dictionary(uniqueKeysWithValues: Terms.allCases.map { ($0, false) })
    }
    
    enum Action {
        case input(Terms)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .input(let index):
            state.isConsented[index]?.toggle()
            return .none
        }
    }
}
