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
        var areas: [Area] = []
        let navigationBarState = NavigationBarReducer.State(
            title: "내 맛집 등록",
            leftButtonKind: .back
        )
        var provinceDropDownPickerState = DropDownPickerReducer.State(
            placeHolder: "광역시 / 도",
            selection: nil,
            options: []
        )
        var cityDropDownPickerState = DropDownPickerReducer.State(
            placeHolder: "시 / 군 / 구",
            selection: nil,
            options: []
        )
        var roadNameAddressTextFieldBarState = TextFieldBarReducer.State(placeHolder: "도로명 주소 입력")
        var restaurantNameTextFieldBarState = TextFieldBarReducer.State(placeHolder: "식당 이름")
        var bottomButtonState = BottomButtonReducer.State(
            title: "다음",
            able: false
        )
        let confirmPopupState = ConfirmPopupReducer.State(
            title: "쉐피에서 식당 정보를 확인하고 있어요",
            description: "등록한 정보가 정확한 정보가 아닐경우\n리뷰가 삭제될 수 있습니다.",
            primaryButtonTitle: "이해했어요",
            optionButtonTitle: "다시 보지 않기"
        )
        var errorPopupState = ConfirmPopupReducer.State(
            title: "일시적인 오류가 발생했습니다.\n서비스 이용에 불편을 드려 죄송합니다.",
            description: "",
            primaryButtonTitle: "확인"
        )
        var isShowConfirmPopup: Bool = false
        var error: String?
    }
    
    enum Action {
        case navigationBarAction(NavigationBarReducer.Action)
        case provinceDropDownPickerAction(DropDownPickerReducer.Action)
        case cityDropDownPickerAction(DropDownPickerReducer.Action)
        case roadNameAddressTextFieldBarAction(TextFieldBarReducer.Action)
        case restaurantNameTextFieldBarAction(TextFieldBarReducer.Action)
        case bottomButtonAction(BottomButtonReducer.Action)
        case setEnableNext
        case confirmPopupAction(ConfirmPopupReducer.Action)
        case errorPopupAction(ConfirmPopupReducer.Action)
        case onAppear
        case getArea
        case successGetArea([Area])
        case registRestaurant
        case successRegist(RestaurantInfoDTO)
        case occerError(Error)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .navigationBarAction(let action):
            switch action {
            case .leftButtonTapped:
                steps.send(.popToNavigationController)
                fallthrough
            default: return .none
            }
        case .provinceDropDownPickerAction(let action):
            switch action {
            case .toggleDropDown:
                state.provinceDropDownPickerState.isShowDropdown.toggle()
                return .none
            case .select(let option):
                state.provinceDropDownPickerState.selection = option
                state.provinceDropDownPickerState.isShowDropdown.toggle()
                state.cityDropDownPickerState = DropDownPickerReducer.State(
                    placeHolder: state.cityDropDownPickerState.placeHolder,
                    selection: nil,
                    options: state.areas.first(where: { $0.province == option })?.cities ?? []
                )
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
        case .errorPopupAction(let action):
            switch action {
            default:
                state.error = nil
                return .none
            }
        case .onAppear:
            return .send(.getArea)
        case .getArea:
            return .publisher {
                useCase.getAreas()
                    .receive(on: UIScheduler.shared)
                    .map(Action.successGetArea)
                    .catch { Just(Action.occerError($0)) }
            }
        case .successGetArea(let areas):
            state.areas = areas
            state.provinceDropDownPickerState = DropDownPickerReducer.State(
                placeHolder: state.provinceDropDownPickerState.placeHolder,
                selection: nil,
                options: areas.map(\.province)
            )
            return .none
        case .registRestaurant:
            guard
                let province = state.provinceDropDownPickerState.selection,
                let city = state.cityDropDownPickerState.selection
            else {
                return .send(.occerError(RequestGenerationError.components))
            }
            let name = state.restaurantNameTextFieldBarState.txt
            let address = Address(
                province: province,
                city: city,
                roadName: state.roadNameAddressTextFieldBarState.txt,
                fullLotNumberAddress: state.roadNameAddressTextFieldBarState.txt,
                fullRodNameAddress: state.roadNameAddressTextFieldBarState.txt
            )
            let restaurant = RestaurantRegistRequest(name: name, detailedAddress: address)
            state.isShowConfirmPopup = false
            return .publisher {
                useCase.registRestaurant(restaurant: restaurant)
                    .receive(on: UIScheduler.shared)
                    .map { 
                        Action.successRegist(
                            RestaurantInfoDTO(
                                id: $0,
                                name: name,
                                address: address,
                                registered: true
                            )
                        )
                    }
                    .catch { Just(Action.occerError($0)) }
            }
        case .successRegist(let restaurant):
            steps.send(.pushReviewCompose(info: restaurant))
            return .none
        case .occerError(let error):
            state.errorPopupState = ConfirmPopupReducer.State(
                title: "일시적인 오류가 발생했습니다.\n서비스 이용에 불편을 드려 죄송합니다.",
                description: error.localizedDescription,
                primaryButtonTitle: "확인"
            )
            state.error = error.localizedDescription
            return .none
        }
    }
}

extension RestaurantRegistComposeReducer: Stepper {}
