//
//  RestaurantInfoComposeReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import Foundation
import Combine
import ComposableArchitecture

struct RestaurantInfoComposeReducer: Reducer {
    private enum Policy {
        static let maxMenuCount = 5
    }
    
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
        var restaurant: RestaurantInfoDTO
        
        var selectedImageDatas: [Data] = []
        
        let navigationBarState = NavigationBarReducer.State(
            title: "내 맛집 등록",
            buttonKind: .back
        )
        var titleTextFieldBarState: TextFieldBarReducer.State
        var mainTextEditorViewState = TextEditorViewReducer.State(
            placeHolder: "음식의 맛, 양, 포장 상태 등 음식에 대한 솔직한 리뷰를 남겨주세요.",
            minCount: 100
        )
        var isShowMenuComposePopup: Bool = false
        var isShowMaxMenuConfirmPopup: Bool = false
        var menuComposePopupState = RestaurantMenuComposePopupReducer.State()
        var maxMenuConfirmPopupState = ConfirmPopupReducer.State(
            title: "메뉴는 최대 5개까지 등록할 수 있어요",
            description: "꼭 정확한 정보를 입력해주세요",
            primaryButtonTitle: "이해했어요"
        )
        var composedMenus: [MenuDTO] = []
        var bottomButtonState = BottomButtonReducer.State(
            title: "다음",
            able: false
        )
    }
    
    enum Action {
        case startCamera
        case startAlbumSelection
        case appendImageDatas([Data?])
        case deselectPhoto(Data)
        case setEnableNext
        case navigaionBarAction(NavigationBarReducer.Action)
        case titleTextFieldBarAction(TextFieldBarReducer.Action)
        case mainTextEditorViewAction(TextEditorViewReducer.Action)
        case tapMenuCompose
        case deleteMenuItem(MenuDTO)
        case menuComposePopupAction(RestaurantMenuComposePopupReducer.Action)
        case maxMenuConfirmPopupAction(ConfirmPopupReducer.Action)
        case bottomButtonAction(BottomButtonReducer.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .startCamera:
            let stepAsync: () async -> Data? = {
                await withCheckedContinuation { continuation in
                    steps.send(.presentCamera(isPresentPhotoAlbum: false, dismissCompletion: {
                        continuation.resume(returning: $0)
                    }))
                }
            }
            return .run { send in
                let datas = await stepAsync()
                await send(.appendImageDatas([datas]))
            }
        case .startAlbumSelection:
            let stepAsync: () async -> [Data?] = {
                await withCheckedContinuation { continuation in
                    steps.send(.presentPhotoAlbum(dismissCompletion: {
                        continuation.resume(returning: $0)
                    }))
                }
            }
            return .run { send in
                let datas = await stepAsync()
                await send(.appendImageDatas(datas))
            }
        case .appendImageDatas(let datas):
            let flatDatas = datas.compactMap { $0 }
            state.selectedImageDatas.append(contentsOf: flatDatas)
            return .send(.setEnableNext)
        case .deselectPhoto(let data):
            state.selectedImageDatas = state.selectedImageDatas.filter { $0 != data }
            return .send(.setEnableNext)
        case .setEnableNext:
            let isValidMainTextMinCount = state.mainTextEditorViewState.minCount != nil
            ? state.mainTextEditorViewState.txt.count >= state.mainTextEditorViewState.minCount!
            : true
            let enable = state.selectedImageDatas.count >= 3 &&
            state.titleTextFieldBarState.txt.isEmpty == false &&
            isValidMainTextMinCount &&
            state.composedMenus.isEmpty == false
            state.bottomButtonState.able = enable
            return .none
        case .navigaionBarAction(let action):
            switch action {
            case .tap:
                steps.send(.popToNavigationController)
                return .none
            }
        case .titleTextFieldBarAction(let action):
            switch action {
            case .input(let txt):
                state.titleTextFieldBarState.txt = txt
                return .send(.setEnableNext)
            }
        case .mainTextEditorViewAction(let action):
            switch action {
            case .input(let txt):
                state.mainTextEditorViewState.txt = txt
                return .send(.setEnableNext)
            }
        case .tapMenuCompose:
            guard state.composedMenus.count < Policy.maxMenuCount else {
                state.isShowMaxMenuConfirmPopup = true
                return .none
            }
            state.menuComposePopupState = RestaurantMenuComposePopupReducer.State()
            state.isShowMenuComposePopup = true
            return .none
        case .deleteMenuItem(let menu):
            state.composedMenus = state.composedMenus.filter { $0 != menu }
            return .send(.setEnableNext)
        case .menuComposePopupAction(let action):
            switch action {
            case .menuNameTextFieldAction(let action):
                switch action {
                case .input(let txt):
                    state.menuComposePopupState.menuNameTextFieldState.txt = txt
                    return .send(.menuComposePopupAction(.setEnableNext))
                }
            case .menuPriceTextFieldAction(let action):
                switch action {
                case .input(let txt):
                    state.menuComposePopupState.menuPriceTextFieldState.txt = txt
                    if state.menuComposePopupState.menuPriceTextFieldState.isNumberOnly {
                        let numberFormatter: NumberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal
                        if let formattedNumber = numberFormatter.number(from: txt) {
                            state.menuComposePopupState.menuPriceTextFieldState.textNumber = Int(truncating: formattedNumber)
                        }
                    }
                    return .send(.menuComposePopupAction(.setEnableNext))
                }
            case .setEnableNext:
                let enableNext = state.menuComposePopupState.menuNameTextFieldState.txt.isEmpty == false &&
                state.menuComposePopupState.menuPriceTextFieldState.txt.isEmpty == false
                state.menuComposePopupState.tappable = enableNext
                return .none
            case .tap:
                state.isShowMenuComposePopup = false
                let menu = MenuDTO(
                    name: state.menuComposePopupState.menuNameTextFieldState.txt,
                    price: state.menuComposePopupState.menuPriceTextFieldState.textNumber ?? 0,
                    description: nil
                )
                state.composedMenus.append(menu)
                return .send(.setEnableNext)
            }
        case .maxMenuConfirmPopupAction:
            state.isShowMaxMenuConfirmPopup = false
            return .none
        case .bottomButtonAction(let action):
            switch action {
            case .tap:
                // TODO: Eli - 맛집정보 해시태그 화면으로 이동
                // steps.send(.hashtag....)
                return .none
            }
        }
    }
}

extension RestaurantInfoComposeReducer: Stepper {}
