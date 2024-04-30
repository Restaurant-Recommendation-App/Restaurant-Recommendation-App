//
//  UserRegistComplReducer.swift
//  Cheffi
//
//  Created by ronick on 2024/04/16.
//

import Foundation
import Combine
import ComposableArchitecture

struct UserRegistComplReducer: Reducer {
    let steps: PassthroughSubject<RouteStep, Never>
    
    init(steps: PassthroughSubject<RouteStep, Never>) {
        self.steps = steps
    }
    
    struct State: Equatable {
        var bottomButtonState = BottomButtonReducer.State(
            title: "프로필 등록하기",
            able: true
        )
    }
    
    enum Action {
        case profileSetupButtonAction(BottomButtonReducer.Action)
        case homeButtonAction
        case moveToProfileSetupVC
        case moveToHomeVC
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .profileSetupButtonAction(let action):
            switch action {
            case .tap:
                return .send(.moveToProfileSetupVC)
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
