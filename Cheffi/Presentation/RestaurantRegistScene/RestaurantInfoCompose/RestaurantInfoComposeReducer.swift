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
            isValidMainTextMinCount
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
