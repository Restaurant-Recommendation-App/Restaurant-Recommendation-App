//
//  NavigationBarReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/21/24.
//

import Foundation
import ComposableArchitecture

struct NavigationBarReducer: Reducer {
    enum LeftButtonKind: String {
        case close = "icClose"
        case back = "icBack"
    }
    
    enum RightButtonKind: String {
        case posting = "게시하기"
        case modification = "수정하기"
        case setting = "setting_icon"
        
        var isImage: Bool {
            switch self {
            case .posting,
                    .modification:
                return false
            case .setting:
                return true
            }
        }
    }
    
    struct State: Equatable {
        let title: String
        let leftButtonKind: LeftButtonKind
        var rightButtonKind: RightButtonKind?
    }
    
    enum Action {
        case leftButtonTapped
        case rightButtonTapped
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
