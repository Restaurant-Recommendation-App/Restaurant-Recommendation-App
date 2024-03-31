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
    private let useCase: ReviewUseCase
    let steps: PassthroughSubject<RouteStep, Never>
    
    init(
        useCase: ReviewUseCase,
        steps: PassthroughSubject<RouteStep, Never>
    ) {
        self.useCase = useCase
        self.steps = steps
    }
    
    struct State: Equatable {
        var reviewRequestInfo: ReviewHashtagsActionType
        
        var allTags: [Tag] = []
        
        var navigationBarState: NavigationBarReducer.State
    }
    
    enum Action {
        case onAppear
        case tagButtonTapped(Tag)
        
        case navigationBarAction(NavigationBarReducer.Action)
        
        case getAllTags
        case successGetAllTags([Tag])
        case successPost(Int)
        case occerError(Error)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .send(.getAllTags)
        case .tagButtonTapped(let tag):
            switch state.reviewRequestInfo {
            case .posting(let reviewRequest, let imageDatas):
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
                state.reviewRequestInfo = .posting(review: review, imageDatas: imageDatas)
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
                return .none
            case .rightButtonTapped:
                switch state.reviewRequestInfo {
                case .posting(let reviewRequest, let imageDatas):
                    return .publisher {
                        useCase.postReviews(registerReviewRequest: reviewRequest, images: imageDatas)
                            .receive(on: UIScheduler.shared)
                            .map(Action.successPost)
                            .catch { Just(Action.occerError($0)) }
                    }
                default:
                    // TODO: Eli - API 호출이 아닌 변경된 태그 저장만 하기
                    return .none
                }
            }
        case .getAllTags:
            return .publisher {
                useCase.getAllTags()
                    .receive(on: UIScheduler.shared)
                    .map(Action.successGetAllTags)
                    .catch { Just(.occerError($0)) }
            }
        case .successGetAllTags(let tags):
            state.allTags = tags
            return .none
        case .successPost(let id):
            // TODO: Eli - 리뷰상세 화면으로 이동
//            steps.send(.......)
            return .none
        case .occerError(let error):
            // TODO: Eli - 에러 핸들링
//            state.error = error.localizedDescription
            return .none
        }
    }
}

extension ReviewHashtagsReducer: Stepper {}
