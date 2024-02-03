//
//  RestaurantRegistComposeReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import Foundation
import Combine
import ComposableArchitecture

struct RestaurantRegistComposeReducer: Reducer {
    let steps: PassthroughSubject<RouteStep, Never>

    init(
        steps: PassthroughSubject<RouteStep, Never>
    ) {
        self.steps = steps
    }
    
    struct State: Equatable {
        let navigationBarState = NavigationBarReducer.State(
            title: "내 맛집 등록",
            buttonKind: .back
        )
        var provinceDropDownPickerState = DropDownPickerReducer.State(
            placeHolder: "광역시 / 도",
            selection: nil,
            options: [
                "서울특별시",
                "인천광역시",
                "부산광역시",
                "서울특별시2",
                "인천광역시2",
                "부산광역시2",
                "서울특별시3",
                "인천광역시3",
                "부산광역시3"
            ]
        )
        var cityDropDownPickerState = DropDownPickerReducer.State(
            placeHolder: "시 / 군 / 구",
            selection: nil,
            options: [
                "강남구",
                "강동구",
                "강북구"
            ]
        )
        var roadNameAddressTextFieldBarState = TextFieldBarReducer.State(placeHolder: "도로명 주소 입력")
        var restaurantNameTextFieldBarState = TextFieldBarReducer.State(placeHolder: "식당 이름")
        var bottomButtonState = BottomButtonReducer.State(
            title: "다음",
            able: false
        )
    }
    
    enum Action {
        case navigaionBarAction(NavigationBarReducer.Action)
        case provinceDropDownPickerAction(DropDownPickerReducer.Action)
        case cityDropDownPickerAction(DropDownPickerReducer.Action)
        case roadNameAddressTextFieldBarAction(TextFieldBarReducer.Action)
        case restaurantNameTextFieldBarAction(TextFieldBarReducer.Action)
        case bottomButtonAction(BottomButtonReducer.Action)
        case setEnableNext
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .provinceDropDownPickerAction(let action):
            switch action {
            case .toggleDropDown:
                state.provinceDropDownPickerState.isShowDropdown.toggle()
                return .none
            case .select(let option):
                state.provinceDropDownPickerState.selection = option
                state.provinceDropDownPickerState.isShowDropdown.toggle()
                return .send(.setEnableNext)
            }
        case .cityDropDownPickerAction(let action):
            switch action {
            case .toggleDropDown:
                state.cityDropDownPickerState.isShowDropdown.toggle()
                return .none
            case .select(let option):
                state.cityDropDownPickerState.selection = option
                state.cityDropDownPickerState.isShowDropdown.toggle()
                return .send(.setEnableNext)
            }
        case .roadNameAddressTextFieldBarAction(let action):
            switch action {
            case .input(let txt):
                state.roadNameAddressTextFieldBarState.txt = txt
                return .send(.setEnableNext)
            }
        case .restaurantNameTextFieldBarAction(let action):
            switch action {
            case .input(let txt):
                state.restaurantNameTextFieldBarState.txt = txt
                return .send(.setEnableNext)
            }
        case .setEnableNext:
            let enable = state.provinceDropDownPickerState.selection != nil &&
            state.cityDropDownPickerState.selection != nil &&
            !state.roadNameAddressTextFieldBarState.txt.isEmpty &&
            !state.restaurantNameTextFieldBarState.txt.isEmpty
            state.bottomButtonState.able = enable
            return .none
        default:
            // TODO: - Eli
            return .none
        }
    }
}

extension RestaurantRegistComposeReducer: Stepper {}
