//
//  TextFieldBarView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/28/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(TextFieldBarReducer.self)
struct TextFieldBarView: View {
    private enum Metrics {
        static let outerHStackPadding = 8.0
        static let barHeight = 48.0
        static let barPadding = 12.0
        static let barCornerRadius = 10.0
        static let barBorderWidth = 1.0
        static let barBorderInset = barBorderWidth / 2
    }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                TextField(
                    "",
                    text: viewStore.binding(get: \.txt, send: { .input($0) }),
                    prompt: Text(viewStore.placeHolder)
                )
                .font(.custom("SUIT", size: 14))
                .foregroundColor(.cheffiGray9)
                .focused($isFocused)
                .onChange(of: viewStore.txt) {
                    if let maxCount = viewStore.maxCount {
                        viewStore.send(.input(String(viewStore.txt.prefix(maxCount))))
                    }
                }
                
                if let maxCount = viewStore.maxCount {
                    Text("\(viewStore.txt.count)/\(maxCount)")
                        .font(.custom("SUIT", size: 14))
                        .foregroundColor(.cheffiGray5)
                }
            }
            .padding(Metrics.barPadding)
            .background(.cheffiWhite)
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.barCornerRadius)
                    .inset(by: Metrics.barBorderInset)
                    .stroke(
                        isFocused ? .cheffiGray9 : .cheffiGray3,
                        lineWidth: Metrics.barBorderWidth
                    )
            )
            .frame(height: Metrics.barHeight)
        }
        .padding(.top, Metrics.outerHStackPadding)
    }
}

struct TextFieldBarView_Preview: PreviewProvider {
    static var previews: some View {
        TextFieldBarView(
            Store(initialState: TextFieldBarReducer.State(
                txt: "",
                placeHolder: "도로명 주소 입력",
                maxCount: 30
            )) {
                TextFieldBarReducer()._printChanges()
            }
        )
    }
}
