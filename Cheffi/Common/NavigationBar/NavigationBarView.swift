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
        static let rightButtonHorizontalPadding = 5.0
        static let navigationHorizontalInset = 16.0
    }
    
    var body: some View {
        HStack {
            Button {
                viewStore.send(.leftButtonTapped)
            } label: {
                Image(viewStore.leftButtonKind.rawValue)
            }
            .frame(width: Metrics.navigationBarViewHeight, alignment: .leading)
            
            Text(viewStore.title)
                .font(.custom("SUIT", size: 16).weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.cheffiBlack)
                .frame(maxWidth: .infinity, alignment: .center)
            
            if let rightButtonKind = viewStore.rightButtonKind {
                Button {
                    viewStore.send(.rightButtonTapped)
                } label: {
                    if rightButtonKind.isImage {
                        Image(rightButtonKind.rawValue)
                    } else {
                        Text(rightButtonKind.rawValue)
                            .font(.custom("SUIT", size: 16).weight(.semibold))
                            .frame(height: Metrics.navigationBarViewHeight)
                            .padding(.horizontal, Metrics.rightButtonHorizontalPadding)
                            .foregroundColor(.mainCTA)
                    }
                }
            } else {
                Spacer(minLength: Metrics.navigationBarViewHeight)
            }
        }
        .frame(height: Metrics.navigationBarViewHeight)
        .padding(.horizontal, Metrics.navigationHorizontalInset)
    }
}

struct NavigationBarView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationBarView(
            Store(initialState: NavigationBarReducer.State(
                title: "내 맛집 등록",
                leftButtonKind: .close,
                rightButtonKind: .posting
            )) {
                NavigationBarReducer()._printChanges()
            }
        )
    }
}
