//
//  RestaurantMenuComposePopupView.swift
//  Cheffi
//
//  Created by 김문옥 on 2/25/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(RestaurantMenuComposePopupReducer.self)
struct RestaurantMenuComposePopupView: View {
    private enum Metrics {
        static let outsidePadding = 24.0
        static let popupViewPadding = EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16)
        static let popupVStackSpacing = 12.0
        static let titleTextBottomPadding = 8.0
        static let buttonTopPadding = 16.0
        static let buttonLabelPadding = 9.0
        static let buttonLabelCornerRadius = 10.0
    }
    
    var body: some View {
        ZStack {
            Color.cheffiDimmed
                .ignoresSafeArea()
            
            GeometryReader {
                VStack(spacing: Metrics.popupVStackSpacing) {
                    VStack(spacing: Metrics.popupVStackSpacing) {
                        Text("추천하는 메뉴를 알려주세요")
                            .font(.custom("SUIT", size: 18).weight(.semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.cheffiGray8)
                            .padding(.bottom, Metrics.titleTextBottomPadding)
                        
                        TextFieldBarView(store.scope(
                            state: \.menuNameTextFieldState,
                            action: RestaurantMenuComposePopupReducer.Action.menuNameTextFieldAction
                        ))
                        
                        TextFieldBarView(store.scope(
                            state: \.menuPriceTextFieldState,
                            action: RestaurantMenuComposePopupReducer.Action.menuPriceTextFieldAction
                        ))
                            
                        Button {
                            viewStore.send(.tap)
                        } label: {
                            Text("작성")
                                .frame(maxWidth: .infinity)
                                .padding(Metrics.buttonLabelPadding)
                                .font(.custom("SUIT", size: 16).weight(.medium))
                                .foregroundColor(viewStore.tappable ? .cheffiWhite : .cheffiGray5)
                                .background(viewStore.tappable ? .mainCTA : .cheffiGray1)
                                .cornerRadius(Metrics.buttonLabelCornerRadius)
                        }
                        .disabled(!viewStore.tappable)
                        .padding(.top, Metrics.buttonTopPadding)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(Metrics.popupViewPadding)
                    .background(.cheffiWhite)
                    .cornerRadius(Metrics.buttonLabelCornerRadius)
                }
                .padding(.horizontal, Metrics.outsidePadding)
                .frame(width: $0.size.width, height: $0.size.height)
            }
        }
    }
}

struct RestaurantMenuComposePopupView_Preview: PreviewProvider {
    static var previews: some View {
        RestaurantMenuComposePopupView(
            Store(
                initialState: RestaurantMenuComposePopupReducer.State(),
                reducer: {
                    RestaurantMenuComposePopupReducer()._printChanges()
                }
            )
        )
    }
}
