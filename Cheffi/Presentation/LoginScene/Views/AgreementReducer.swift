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
        
        let navigationBarState = NavigationBarReducer.State(
            title: "",
            leftButtonKind: .back
        )
        var bottomButtonState = BottomButtonReducer.State(
            title: "다음",
            able: false
        )
    }

    enum Action {
        case bottomButtonAction(BottomButtonReducer.Action)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        default: return .none
        }
    }
}

extension AgreementReducer: Stepper { }
