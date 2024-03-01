//
//  BottomButtonView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/27/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(BottomButtonReducer.self)
struct BottomButtonView: View {
    private enum Metrics {
        static let buttonViewPadding = 16.0
        static let overlayPositionOffsetSize = CGSize(width: 0, height: -buttonViewPadding)
        static let buttonPadding = 12.0
        static let buttonCornerRadius = 10.0
    }
    var body: some View {
        HStack {
            Button {
                viewStore.send(.tap)
            } label: {
                Text(viewStore.title)
                    .frame(maxWidth: .infinity)
                    .padding(Metrics.buttonPadding)
                    .foregroundColor(viewStore.able ? .cheffiWhite : .cheffiGray5)
                    .background(viewStore.able ? .mainCTA : .cheffiGray1)
                    .cornerRadius(Metrics.buttonCornerRadius)
            }
            .disabled(!viewStore.able)
        }
        .padding(.bottom, Metrics.buttonViewPadding)
        .overlay {
            GeometryReader { _ in
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .cheffiWhite]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: Metrics.buttonViewPadding)
                .offset(Metrics.overlayPositionOffsetSize)
            }
        }
    }
}

struct BottomButtonView_Preview: PreviewProvider {
    static var previews: some View {
        BottomButtonView(
            Store(initialState: BottomButtonReducer.State(
                title: "다음",
                able: true
            )) {
                BottomButtonReducer()._printChanges()
            }
        )
    }
}
