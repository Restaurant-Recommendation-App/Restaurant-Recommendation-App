//
//  NavigationBarView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/1/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(NavigationBarReducer.self)
struct NavigationBarView: View {
    private enum Metrics {
        static let navigationBarViewHeight = 44.0
        static let navigationHorizontalInset = 16.0
    }
    
    var body: some View {
        HStack {
            Button {
                viewStore.send(.tap)
            } label: {
                Image(viewStore.buttonKind.rawValue)
            }
            .frame(width: Metrics.navigationBarViewHeight, alignment: .leading)
            
            Text(viewStore.title)
                .font(
                    Font.custom("SUIT", size: 16)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.cheffiBlack)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer(minLength: Metrics.navigationBarViewHeight)
        }
        .frame(height: Metrics.navigationBarViewHeight)
    }
}

struct NavigationBarView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationBarView(
            Store(initialState: NavigationBarReducer.State(
                title: "내 맛집 등록",
                buttonKind: .close
            )) {
                NavigationBarReducer()._printChanges()
            }
        )
    }
}
