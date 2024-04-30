//
//  ReviewThumbnailListReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 4/20/24.
//

import Foundation
import ComposableArchitecture

struct ReviewThumbnailListReducer: Reducer {
    struct State: Equatable {
        var reviews: [ReviewInfoDTO] = []
    }
    
    enum Action {
        case tap(ReviewInfoDTO)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
