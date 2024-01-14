//
//  SearchBarView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/1/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore
 
@ViewStore(SearchBarReducer.self)
struct SearchBarView: View {
    private enum Metrics {
        static let barPaddingEdgeInsets = EdgeInsets(top: 20.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
        static let barHeight = 40.0
        static let barCornerRadius = 6.0
    }
 
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField(
                    "",
                    text: viewStore.binding(get: \.searchQuery, send: { .input($0) }),
                    prompt: Text("등록할 맛집의 상호명을 입력하세요.")
                )
                .foregroundColor(.cheffiBlack)
                
                if !viewStore.searchQuery.isEmpty {
                    Button(action: {
                        viewStore.send(.input(""))
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .padding()
            .frame(height: Metrics.barHeight)
            .foregroundColor(.cheffiBlack)
            .background(.cheffiWhite05)
            .cornerRadius(Metrics.barCornerRadius)
        }
        .padding(Metrics.barPaddingEdgeInsets)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(
            Store(initialState: SearchBarReducer.State()) {
                SearchBarReducer()._printChanges()
            }
        )
    }
}
