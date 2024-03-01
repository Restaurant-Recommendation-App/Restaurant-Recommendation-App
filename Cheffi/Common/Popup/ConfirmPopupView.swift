//
//  ConfirmPopupView.swift
//  Cheffi
//
//  Created by 김문옥 on 2/4/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(ConfirmPopupReducer.self)
struct ConfirmPopupView: View {
    private enum Metrics {
        static let outsidePadding = 24.0
        static let popupViewPadding = EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16)
        static let popupVStackSpacing = 12.0
        static let buttonsHStackTopPadding = 12.0
        static let buttonsHStackSpacing = 8.0
        static let buttonPadding = 9.0
        static let buttonCornerRadius = 10.0
    }
    
    var body: some View {
        ZStack {
            Color.cheffiDimmed
                .ignoresSafeArea()
            
            GeometryReader {
                VStack(spacing: Metrics.popupVStackSpacing) {
                    VStack(spacing: Metrics.popupVStackSpacing) {
                        Text(viewStore.title)
                            .font(.custom("SUIT", size: 18).weight(.semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.cheffiGray8)
                        
                        Text(viewStore.description)
                            .font(.custom("SUIT", size: 15))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.cheffiGray6)
                        
                        HStack(spacing: Metrics.buttonsHStackSpacing) {
                            if let secondaryButtonTitle = viewStore.secondaryButtonTitle {
                                Button {
                                    viewStore.send(.secondary)
                                } label: {
                                    Text(secondaryButtonTitle)
                                        .frame(maxWidth: .infinity)
                                        .padding(Metrics.buttonPadding)
                                        .font(.custom("SUIT", size: 16).weight(.medium))
                                        .foregroundColor(.cheffiGray6)
                                        .background(.cheffiWhite05)
                                        .cornerRadius(Metrics.buttonCornerRadius)
                                }
                            }
                            
                            Button {
                                viewStore.send(.primary)
                            } label: {
                                Text(viewStore.primaryButtonTitle)
                                    .frame(maxWidth: .infinity)
                                    .padding(Metrics.buttonPadding)
                                    .font(.custom("SUIT", size: 16).weight(.medium))
                                    .foregroundColor(.cheffiWhite)
                                    .background(.mainCTA)
                                    .cornerRadius(Metrics.buttonCornerRadius)
                            }
                        }
                        .padding(.top, Metrics.buttonsHStackTopPadding)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(Metrics.popupViewPadding)
                    .background(.cheffiWhite)
                    .cornerRadius(Metrics.buttonCornerRadius)
                    
                    if let optionButtonTitle = viewStore.optionButtonTitle {
                        Button {
                            viewStore.send(.option)
                        } label: {
                            Text(optionButtonTitle)
                                .frame(maxWidth: .infinity)
                                .padding(Metrics.buttonPadding)
                                .font(.custom("SUIT", size: 16).weight(.medium))
                                .foregroundColor(.cheffiWhite)
                        }
                    }
                }
                .padding(.horizontal, Metrics.outsidePadding)
                .frame(width: $0.size.width, height: $0.size.height)
            }
        }
    }
}

struct ConfirmPopupView_Preview: PreviewProvider {
    static var previews: some View {
        ConfirmPopupView(
            Store(initialState: ConfirmPopupReducer.State(
                title: "쉐피에서 식당 정보를 확인하고 있어요",
                description: "등록한 정보가 정확한 정보가 아닐경우\n리뷰가 삭제될 수 있습니다.",
                primaryButtonTitle: "이해했어요",
                secondaryButtonTitle: "취소",
                optionButtonTitle: "다시 보지 않기"
            )) {
                ConfirmPopupReducer()._printChanges()
            }
        )
    }
}
