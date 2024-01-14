//
//  EmptyViewButton.swift
//  Cheffi
//
//  Created by 김문옥 on 1/7/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(EmptyViewButtonReducer.self)
struct EmptyViewButton: View {
    private enum Metrics {
        static let cornerRadius = 10.0
        static let padding = EdgeInsets(top: 9.0, leading: 14.0, bottom: 9.0, trailing: 14.0)
    }
    var body: some View {
        Button(action: {
            viewStore.send(.tapButton)
        }, label: {
            Text(viewStore.title)
        })
        .font(
            Font.custom("SUIT", size: 15)
                .weight(.semibold)
        )
        .padding(Metrics.padding)
        .foregroundColor(.main)
        .background(.bg)
        .cornerRadius(Metrics.cornerRadius)
    }
}

struct EmptyViewButton_Preview: PreviewProvider {
    static var previews: some View {
        EmptyViewButton(
            Store(
                initialState: EmptyViewButtonReducer.State(title: "맛집 직접 등록하기")
            ) {
                EmptyViewButtonReducer()._printChanges()
            }
        )
    }
}
