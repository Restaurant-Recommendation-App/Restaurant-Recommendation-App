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
    let useCase: RestaurantUseCase
    let steps: PassthroughSubject<RouteStep, Never>

    init(
        useCase: RestaurantUseCase,
        steps: PassthroughSubject<RouteStep, Never>
    ) {
        self.useCase = useCase
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
        var bottomButtonState = ConfirmButtonReducer.State(
            title: "다음",
            able: false
        )
        let confirmPopupState = ConfirmPopupReducer.State(
            title: "쉐피에서 식당 정보를 확인하고 있어요",
            description: "등록한 정보가 정확한 정보가 아닐경우\n리뷰가 삭제될 수 있습니다.",
            primaryButtonTitle: "이해했어요",
            secondaryButtonTitle: nil,
            optionButtonTitle: "다시 보지 않기"
        )
        var isShowConfirmPopup: Bool = false
        var error: String?
    }
    
    enum Action {
        case navigaionBarAction(NavigationBarReducer.Action)
        case provinceDropDownPickerAction(DropDownPickerReducer.Action)
        case cityDropDownPickerAction(DropDownPickerReducer.Action)
        case roadNameAddressTextFieldBarAction(TextFieldBarReducer.Action)
        case restaurantNameTextFieldBarAction(TextFieldBarReducer.Action)
        case bottomButtonAction(ConfirmButtonReducer.Action)
        case setEnableNext
        case confirmPopupAction(ConfirmPopupReducer.Action)
        case registRestaurant
        case successRegist(RestaurantInfoDTO)
        case occerError(Error)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .navigaionBarAction(let action):
            switch action {
            case .tap:
                steps.send(.popToNavigationController)
                return .none
            }
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
        case .bottomButtonAction(let action):
            switch action {
            case .tap:
                if UserDefaultsManager.Understanding.reviewCanBeDeleted {
                    return .send(.registRestaurant)
                } else {
                    state.isShowConfirmPopup = true
                    return .none
                }
            }
        case .confirmPopupAction(let action):
            switch action {
            case .option:
                UserDefaultsManager.Understanding.reviewCanBeDeleted = true
                fallthrough
            case .primary:
                return .send(.registRestaurant)
            default:
                state.isShowConfirmPopup = false
                return .none
            }
        case .registRestaurant:
            guard
                let province = state.provinceDropDownPickerState.selection,
                let city = state.cityDropDownPickerState.selection
            else {
                return .send(.occerError(RequestGenerationError.components))
            }
            let address = Address(
                province: province,
                city: city,
                lotNumber: state.roadNameAddressTextFieldBarState.txt,
                roadName: state.roadNameAddressTextFieldBarState.txt,
                fullLotNumberAddress: state.roadNameAddressTextFieldBarState.txt,
                fullRodNameAddress: state.roadNameAddressTextFieldBarState.txt
            )
            let restaurant = RestaurantInfoDTO(
                id: 0,
                name: state.restaurantNameTextFieldBarState.txt,
                address: address,
                registered: false
            )
            state.isShowConfirmPopup = false
            return .publisher {
                useCase.registRestaurant(restaurant: restaurant)
                    .map { _ in Action.successRegist(restaurant) }
                    .catch { Just(Action.occerError($0)) }
            }
        case .successRegist(let restaurant):
            steps.send(.pushRestaurantInfoCompose(info: restaurant))
            return .none
        case .occerError(let error):
            state.error = error.localizedDescription
            return .none
        }
    }
}

extension RestaurantRegistComposeReducer: Stepper {}
