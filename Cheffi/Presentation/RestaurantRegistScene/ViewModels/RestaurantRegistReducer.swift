//
//  RestaurantRegistReducer.swift
//  Cheffi
//
//  Created by Eli_01 on 12/17/23.
//

import Foundation
import Combine
import ComposableArchitecture

struct RestaurantRegistReducer: Reducer {
    let useCase: RestaurantUseCase

    init(useCase: RestaurantUseCase) {
        self.useCase = useCase
    }

    struct State: Equatable {
        var error: String?
        var isEmptyNearRestaurant: Bool = false
        var isEmptyRestaurant: Bool = false
        
        var searchBarState = SearchBarReducer.State()
        var nearRestaurantListState = NearRestaurantListReducer.State()
        var nearRestaurantEmptyState = EmptyDescriptionViewReducer.State(
            imageName: "empty_near_restaurant",
            descriptionText: "성동구 근처 맛집등록 된 곳이 없어요\n첫 맛집을 발굴해볼까요?",
            emptyViewButtonState: EmptyViewButtonReducer.State(title: "맛집 직접 등록하기")
        )
        var restaurantListState = RestaurantListReducer.State()
        var restaurantEmptyState = EmptyDescriptionViewReducer.State(
            imageName: "empty_restaurant",
            descriptionText: "찾고있는 맛집이 없나요?",
            emptyViewButtonState: EmptyViewButtonReducer.State(title: "맛집 직접 등록하기")
        )
        var emptyViewButtonState = EmptyViewButtonReducer.State(title: "등록하기")
    }

    enum Action {
        case onAppear
        case getNearRestaurants([RestaurantInfoDTO])
        case getRestaurants([RestaurantInfoDTO])
        case occerError(DataTransferError)
        
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
                useCase.getRestaurants(name: "Daughter", province: "", city: "")
                    .map(Action.getNearRestaurants)
                    .catch { Just(Action.occerError($0)) }
            }
        case .getNearRestaurants(let list):
            state.isEmptyNearRestaurant = list.isEmpty
            state.nearRestaurantListState.nearRestaurantList = list
            return .none
        case .getRestaurants(let list):
            state.isEmptyRestaurant = list.isEmpty
            state.restaurantListState.restaurantList = list
            return .none
        case .occerError(let error):
            state.error = error.localizedDescription
            return .none
        case .searchBarAction(let action):
            switch action {
            case .input(let text):
                state.searchBarState.searchQuery = text
                return .publisher {
                    useCase.getRestaurants(name: text, province: "", city: "")
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
                    // TODO: Eli - 화면이동
                    return .none
                }
            }
        case .emptyViewButtonAction(let action):
            switch action {
            case .tapButton:
                // TODO: Eli - 화면이동
                return .none
            }
        }
    }
}
