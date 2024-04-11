//
//  AgreementReducer.swift
//  Cheffi
//
//  Created by ronick on 2024/03/31.
//

import Foundation
import Combine
import ComposableArchitecture

struct AgreementReducer: Reducer {
    private let useCase: AuthUseCase
    let steps: PassthroughSubject<RouteStep, Never>

    init(
        useCase: AuthUseCase,
        steps: PassthroughSubject<RouteStep, Never>
    ) {
        self.useCase = useCase
        self.steps = steps
    }

    struct State: Equatable {
        var error: String?
        var isAllConsented: Bool = false
        
        let navigationBarState = NavigationBarReducer.State(
            title: "",
            leftButtonKind: .back
        )
        
        var agreementListState = AgreementListViewReducer.State()
        var bottomButtonState = BottomButtonReducer.State(
            title: "다음",
            able: false
        )
    }

    enum Action {
        case consentAllAction
        case tappedCheckBox(AgreementListViewReducer.Action)
        case bottomButtonAction(BottomButtonReducer.Action)
        
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .consentAllAction:
            state.agreementListState.isConsented.forEach { (term, _) in
                state.agreementListState.isConsented[term] = true
            }
            state.isAllConsented = true
            state.bottomButtonState.able = true
            return .none
        case .tappedCheckBox(let action):
            switch action {
            case .input(let term):
                state.agreementListState.isConsented[term]?.toggle()
                state.isAllConsented = state.agreementListState.isConsented.contains(where: { $0.value == false }) == false
                state.bottomButtonState.able = 
                (state.agreementListState.isConsented
                    .filter { 0...3 ~= $0.key.rawValue }.map { $0.value}
                    .contains(false)
                ) == false
                
                return .none
            }
        default: return .none
        }
    }
}

extension AgreementReducer: Stepper { }
