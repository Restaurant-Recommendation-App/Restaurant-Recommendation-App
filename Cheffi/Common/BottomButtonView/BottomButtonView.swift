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
                    .disabled(!viewStore.able)
                    .foregroundColor(viewStore.able ? .cheffiWhite : .cheffiGray5)
                    .background(viewStore.able ? .mainCTA : .cheffiGray1)
                    .cornerRadius(Metrics.buttonCornerRadius)
            }
        }
        .padding(.vertical, Metrics.buttonViewPadding)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.clear, .cheffiWhite, .cheffiWhite]),
                startPoint: .top,
                endPoint: .center
            )
        )
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
