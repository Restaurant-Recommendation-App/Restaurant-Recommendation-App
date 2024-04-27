//
//  MyPageReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 4/5/24.
//

import Foundation
import Combine
import ComposableArchitecture

struct MyPageReducer: Reducer {
    let steps: PassthroughSubject<RouteStep, Never>
    
    init(
        steps: PassthroughSubject<RouteStep, Never>
    ) {
        self.steps = steps
    }
    
    struct State: Equatable {
        let navigationBarState = NavigationBarReducer.State(
            title: "마이페이지",
            leftButtonKind: .back,
            rightButtonKind: .setting
        )
        
        var allTags: [Tag] = [
            // TODO: API 응답으로
            Tag(id: 0, type: .food, name: "매콤한"),
            Tag(id: 1, type: .food, name: "노포"),
            Tag(id: 2, type: .food, name: "웨이팅 짧은"),
            Tag(id: 3, type: .food, name: "아시아음식"),
            Tag(id: 4, type: .food, name: "한식"),
            Tag(id: 5, type: .food, name: "비건"),
            Tag(id: 6, type: .food, name: "분위기 있는 곳")
        ]
    }
    
    enum Action {
        case onAppear
        case navigationBarAction(NavigationBarReducer.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .navigationBarAction(let action):
            switch action {
            case .rightButtonTapped:
                // TODO: - 프로필 수정 화면 띄우기
//                steps.send(.presentSetting)
                return .none
            default: return .none
            }
        default: return .none
        }
    }
}

extension MyPageReducer: Stepper {}
