//
//  ProfileRegistCompleReducer.swift
//  Cheffi
//
//  Created by ronick on 2024/04/20.
//

import Combine
import ComposableArchitecture


struct ProfileRegistCompleReducer: Reducer {
    let steps: PassthroughSubject<RouteStep, Never>
    
    init(steps: PassthroughSubject<RouteStep, Never>) {
        self.steps = steps
    }
    
    struct State: Equatable {
        var bottomButtonState = BottomButtonReducer.State(
            title: "시작하기",
            able: true
        )
    }
    
    enum Action {
        case startButtonAction(BottomButtonReducer.Action)
        case homeButtonAction
        case moveToProfileSetupVC
        case moveToHomeVC
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .startButtonAction(let action):
            switch action {
            case .tap:
                return .send(.moveToHomeVC)
            }
        case .homeButtonAction:
            return .send(.moveToHomeVC)
        case .moveToProfileSetupVC:
            steps.send(.pushProfileSetupViewController)
            return .none
        case .moveToHomeVC:
            steps.send(.popToNavigationController)
            return .none
        }
    }

}
