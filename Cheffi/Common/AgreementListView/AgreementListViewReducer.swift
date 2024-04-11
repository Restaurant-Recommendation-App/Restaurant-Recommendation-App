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
        var isConsented: [Term: Bool] = Dictionary(uniqueKeysWithValues: Term.allCases.map { ($0, false) })
    }
    
    enum Action {
        case input(Term)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .input(let index):
            state.isConsented[index]?.toggle()
            return .none
        }
    }
}
