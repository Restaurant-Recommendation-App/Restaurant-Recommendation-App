//
//  RestaurantRegistComposeView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(RestaurantRegistComposeReducer.self)
struct RestaurantRegistComposeView: View {
    private enum Metrics {
        static let safeAreaPadding = 16.0
        static let headlineTextPadding = EdgeInsets(top: 32.0, leading: 0, bottom: 4.0, trailing: 0)
        static let titleTextTopPadding = 20.0
        static let dropDownPickerPadding = 8.0
        static let dropDownPickerHStackHeight = 48.0
        static let dropDownPickerSpacing = 9.0
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavigationBarView(store.scope(
                    state: \.navigationBarState,
                    action: RestaurantRegistComposeReducer.Action.navigaionBarAction
                ))
                
                Text("등록하는 식당의\n정보를 알려주세요.")
                    .font(.custom("SUIT", size: 20).weight(.bold))
                    .foregroundColor(.cheffiGray8)
                    .padding(Metrics.headlineTextPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("주소")
                    .font(.custom("SUIT", size: 14).weight(.bold))
                    .foregroundColor(.cheffiGray8)
                    .padding(.top, Metrics.titleTextTopPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 0) {
                    DropDownPickerView(store.scope(
                        state: \.provinceDropDownPickerState,
                        action: RestaurantRegistComposeReducer.Action.provinceDropDownPickerAction
                    ))
                    
                    Spacer()
                        .frame(width: Metrics.dropDownPickerSpacing)
                    
                    DropDownPickerView(store.scope(
                        state: \.cityDropDownPickerState,
                        action: RestaurantRegistComposeReducer.Action.cityDropDownPickerAction
                    ))
                    
                }
                .frame(height: Metrics.dropDownPickerHStackHeight)
                .padding(.top, Metrics.dropDownPickerPadding)
                .zIndex(10) // 드롭다운이 다른 모든 뷰들을 바닥에 깔고 그 위에 보일 수 있도록
                
                TextFieldBarView(store.scope(
                    state: \.roadNameAddressTextFieldBarState,
                    action: RestaurantRegistComposeReducer.Action.roadNameAddressTextFieldBarAction
                ))
                
                Text("식당이름")
                    .font(.custom("SUIT", size: 14).weight(.bold))
                    .foregroundColor(.cheffiGray8)
                    .padding(.top, Metrics.titleTextTopPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextFieldBarView(store.scope(
                    state: \.restaurantNameTextFieldBarState,
                    action: RestaurantRegistComposeReducer.Action.restaurantNameTextFieldBarAction
                ))
                
                Spacer()
                
                BottomButtonView(store.scope(
                    state: \.bottomButtonState,
                    action: RestaurantRegistComposeReducer.Action.bottomButtonAction
                ))
            }
            .padding(.horizontal, Metrics.safeAreaPadding)
            
            if viewStore.isShowConfirmPopup {
                ConfirmPopupView(store.scope(
                    state: \.confirmPopupState,
                    action: RestaurantRegistComposeReducer.Action.confirmPopupAction
                ))
            }
        }
        .animation(.default, value: viewStore.isShowConfirmPopup)
    }
}

struct RestaurantRegistComposeView_Preview: PreviewProvider {
    static var previews: some View {
        RestaurantRegistComposeView(
            Store(initialState: RestaurantRegistComposeReducer.State(
                isShowConfirmPopup: false
            )) {
                RestaurantRegistComposeReducer(
                    useCase: PreviewRestaurantRegistUseCase(),
                    steps: PassthroughSubject<RouteStep, Never>()
                )._printChanges()
            }
        )
    }
}
