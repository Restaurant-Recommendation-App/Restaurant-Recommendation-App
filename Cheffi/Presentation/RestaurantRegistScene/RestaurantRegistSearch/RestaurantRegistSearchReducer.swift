//
//  RestaurantRegistSearchReducer.swift
//  Cheffi
//
//  Created by Eli_01 on 12/17/23.
//

import Foundation
import Combine
import ComposableArchitecture

struct RestaurantRegistSearchReducer: Reducer {
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
        var error: String?
        var isEmptyNearRestaurant: Bool = false
        var isEmptyRestaurant: Bool = false
        
        let navigationBarState = NavigationBarReducer.State(
            title: "내 맛집 등록",
            leftButtonKind: .close
        )
        var searchBarState = SearchBarReducer.State()
        var nearRestaurantListState = NearRestaurantListReducer.State()
        let nearRestaurantEmptyState = EmptyDescriptionViewReducer.State(
            imageName: "empty_near_restaurant",
            descriptionText: "내 주변 맛집등록 된 곳이 없어요\n첫 맛집을 발굴해볼까요?",
            emptyViewButtonState: EmptyViewButtonReducer.State(title: "맛집 직접 등록하기")
        )
        var restaurantListState = RestaurantListReducer.State()
        let restaurantEmptyState = EmptyDescriptionViewReducer.State(
            imageName: "empty_restaurant",
            descriptionText: "찾고있는 맛집이 없나요?",
            emptyViewButtonState: EmptyViewButtonReducer.State(title: "맛집 직접 등록하기")
        )
        let emptyViewButtonState = EmptyViewButtonReducer.State(title: "등록하기")
    }

    enum Action {
        case onAppear
        case getNearRestaurants([RestaurantInfoDTO])
        case getRestaurants([RestaurantInfoDTO])
        case occerError(DataTransferError)
        
        case navigationBarAction(NavigationBarReducer.Action)
        case searchBarAction(SearchBarReducer.Action)
        case nearRestaurantListAction(NearRestaurantListReducer.Action)
        case nearRestaurantEmptyAction(EmptyDescriptionViewReducer.Action)
        case restaurantListAction(RestaurantListReducer.Action)
        case restaurantEmptyAction(EmptyDescriptionViewReducer.Action)
        case emptyViewButtonAction(EmptyViewButtonReducer.Action)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .publisher {
                useCase.getNearRestaurants()
                    .receive(on: UIScheduler.shared)
                    .map(Action.getNearRestaurants)
                    .catch { Just(Action.occerError($0)) }
            }
        case .getNearRestaurants(let list):
//            state.isEmptyNearRestaurant = list.isEmpty
            state.isEmptyNearRestaurant = true
            state.nearRestaurantListState.nearRestaurantList = list
            return .none
        case .getRestaurants(let list):
            state.isEmptyRestaurant = list.isEmpty
            state.restaurantListState.restaurantList = list
            return .none
        case .occerError(let error):
            state.error = error.localizedDescription
            return .none
        case .navigationBarAction(let action):
            switch action {
            case .leftButtonTapped:
                steps.send(.dismissRestaurantRegist)
                fallthrough
            default: return .none
            }
        case .searchBarAction(let action):
            switch action {
            case .input(let text):
                state.searchBarState.searchQuery = text
                state.restaurantListState.highlightKeyword = text
                return .publisher {
                    useCase.getRestaurants(name: text, province: "", city: "")
                        .receive(on: UIScheduler.shared)
                        .map(Action.getRestaurants)
                        .catch { Just(Action.occerError($0)) }
                }
            }
        case .nearRestaurantEmptyAction(let action),
                .restaurantEmptyAction(let action):
            switch action {
            case .emptyViewButtonAction(let action):
                switch action {
                case .tapButton:
                    steps.send(.pushRestaurantRegistCompose)
                    return .none
                }
            }
        case .emptyViewButtonAction(let action):
            switch action {
            case .tapButton:
                steps.send(.pushRestaurantRegistCompose)
                return .none
            }
        case .restaurantListAction(let action):
            switch action {
            case .tap(let item):
                steps.send(.pushReviewCompose(info: item))
                return .none
            }
        }
    }
}

extension RestaurantRegistSearchReducer: Stepper {}
