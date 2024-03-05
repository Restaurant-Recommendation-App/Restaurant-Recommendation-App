//
//  ReviewHashtagsReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 3/2/24.
//

import Foundation
import Combine
import ComposableArchitecture

struct ReviewHashtagsReducer: Reducer {
    private let useCase: RestaurantUseCase
    let steps: PassthroughSubject<RouteStep, Never>
    
    init(
        useCase: RestaurantUseCase,
        steps: PassthroughSubject<RouteStep, Never>
    ) {
        self.useCase = useCase
        self.steps = steps
    }
    
    struct State: Equatable {
        var reviewRequestInfo: ReviewHashtagsActionType
        
        var allTags: [TagDTO] = []
        
        var navigationBarState: NavigationBarReducer.State
    }
    
    enum Action {
        case onAppear
        case tagButtonTapped(TagDTO)
        
        case navigationBarAction(NavigationBarReducer.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            // TODO: API call - get all tags
            let allTags = [
                TagDTO(id: 0, type: .food, name: "한식"),
                TagDTO(id: 1, type: .food, name: "일식"),
                TagDTO(id: 2, type: .food, name: "중식"),
                TagDTO(id: 3, type: .food, name: "샐러드"),
                TagDTO(id: 4, type: .food, name: "해산물"),
                TagDTO(id: 5, type: .food, name: "빵집"),
                TagDTO(id: 6, type: .food, name: "분식"),
                TagDTO(id: 7, type: .food, name: "면/국수"),
                TagDTO(id: 8, type: .food, name: "돈까스"),
                TagDTO(id: 9, type: .food, name: "피자"),
                TagDTO(id: 10, type: .food, name: "치킨"),
                TagDTO(id: 10, type: .taste, name: "매콤한"),
                TagDTO(id: 12, type: .taste, name: "자극적인"),
                TagDTO(id: 13, type: .taste, name: "달콤한"),
                TagDTO(id: 14, type: .taste, name: "시원한"),
                TagDTO(id: 15, type: .taste, name: "깔끔한"),
                TagDTO(id: 16, type: .taste, name: "깊은맛"),
                TagDTO(id: 17, type: .taste, name: "감성적인"),
                TagDTO(id: 18, type: .taste, name: "사진맛집"),
                TagDTO(id: 19, type: .taste, name: "혼술"),
                TagDTO(id: 20, type: .taste, name: "혼밥")
            ]
            state.allTags = allTags
            return .none
        case .tagButtonTapped(let tag):
            switch state.reviewRequestInfo {
            case .posting(let reviewRequest):
                var foodTags = reviewRequest.tag.foodTags
                var tasteTags = reviewRequest.tag.tasteTags
                switch tag.type {
                case .food:
                    if foodTags.contains(where: { $0 == tag.id }) {
                        foodTags = foodTags.filter { $0 != tag.id }
                    } else {
                        foodTags.append(tag.id)
                    }
                case .taste:
                    if tasteTags.contains(where: { $0 == tag.id }) {
                        tasteTags = tasteTags.filter { $0 != tag.id }
                    } else {
                        tasteTags.append(tag.id)
                    }
                }
                let review = RegisterReviewRequest(
                    restaurantId: reviewRequest.restaurantId,
                    registered: reviewRequest.registered,
                    title: reviewRequest.title,
                    text: reviewRequest.text,
                    menus: reviewRequest.menus,
                    tag: TagsChangeRequest(foodTags: foodTags, tasteTags: tasteTags)
                )
                state.reviewRequestInfo = .posting(review)
            case .modification(let tagsRequest):
                var foodTags = tagsRequest.foodTags
                var tasteTags = tagsRequest.tasteTags
                switch tag.type {
                case .food:
                    if foodTags.contains(where: { $0 == tag.id }) {
                        foodTags = foodTags.filter { $0 != tag.id }
                    } else {
                        foodTags.append(tag.id)
                    }
                case .taste:
                    if tasteTags.contains(where: { $0 == tag.id }) {
                        tasteTags = tasteTags.filter { $0 != tag.id }
                    } else {
                        tasteTags.append(tag.id)
                    }
                }
                let tags = TagsChangeRequest(foodTags: foodTags, tasteTags: tasteTags)
                state.reviewRequestInfo = .modification(tags)
            }
            return .none
        case .navigationBarAction(let action):
            switch action {
            case .leftButtonTapped:
                steps.send(.popToNavigationController)
                fallthrough
            default: return .none
            }
        }
    }
}

extension ReviewHashtagsReducer: Stepper {}
