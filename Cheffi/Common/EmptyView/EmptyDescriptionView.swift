//
//  EmptyDescriptionView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/7/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(EmptyDescriptionViewReducer.self)
struct EmptyDescriptionView: View {
    private enum Metrics {
        static let imageTopHeight = 83.0
        static let descriptionTopHeight = 18.0
    }
    var body: some View {
        VStack {
            Spacer().frame(height: Metrics.imageTopHeight)
            
            Image(viewStore.imageName)
            
            Spacer()
                .frame(height: Metrics.descriptionTopHeight)
            
            Text(viewStore.descriptionText)
                .font(
                    Font.custom("SUIT", size: 14)
                        .weight(.medium)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.cheffiGray6)
            
            Spacer()
                .frame(height: Metrics.descriptionTopHeight)
            
            EmptyViewButton(store.scope(
                state: \.emptyViewButtonState,
                action: EmptyDescriptionViewReducer.Action.emptyViewButtonAction
            ))
        }
    }
}

struct NearRestaurantEmptyView_Preview: PreviewProvider {
    static var previews: some View {
        EmptyDescriptionView(
            Store(
                initialState: EmptyDescriptionViewReducer.State(
                    imageName: "empty_near_restaurant",
                    descriptionText: "내 주변 맛집등록 된 곳이 없어요\n첫 맛집을 발굴해볼까요?",
                    emptyViewButtonState: EmptyViewButtonReducer.State(title: "맛집 직접 등록하기")
                )
            ) {
                EmptyDescriptionViewReducer()._printChanges()
            }
        )
    }
}
