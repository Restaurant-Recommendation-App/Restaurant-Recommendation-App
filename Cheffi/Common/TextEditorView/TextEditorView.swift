//
//  TextEditorView.swift
//  Cheffi
//
//  Created by 김문옥 on 2/19/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(TextEditorViewReducer.self)
struct TextEditorView: View {
    private enum Metrics {
        static let outerHStackPadding = 8.0
        static let viewPadding = 12.0
        static let viewCornerRadius = 10.0
        static let viewBorderWidth = 1.0
        static let viewBorderInset = viewBorderWidth / 2
        static let placeholderPadding = 5.0
    }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            VStack {
                ZStack(alignment: .leading) {
                    if viewStore.txt.isEmpty {
                        let atLeastMinCount = viewStore.minCount != nil ? " (최소 \(viewStore.minCount!)글자)" : ""
                        VStack {
                            Text("\(viewStore.placeHolder)\(atLeastMinCount)")
                                .font(.custom("SUIT", size: 14))
                                .foregroundColor(.cheffiGray5)
                            
                            Spacer()
                        }
                        .padding(Metrics.placeholderPadding)
                    }
                    
                    TextEditor(text: viewStore.binding(get: \.txt, send: { .input($0) }))
                        .font(Font.custom("SUIT", size: 14))
                        .foregroundColor(.cheffiGray8)
                        .focused($isFocused)
                        .opacity(viewStore.txt.isEmpty ? 0.25 : 1)
                }
                
                if
                    let minCount = viewStore.minCount,
                    viewStore.txt.count < minCount
                {
                    HStack {
                        Spacer()
                        
                        Text("현재 글자수 : \(viewStore.txt.count)")
                            .font(.custom("SUIT", size: 14))
                            .foregroundColor(.cheffiRed)
                    }
                }
            }
            .padding(Metrics.viewPadding)
            .background(.cheffiWhite)
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.viewCornerRadius)
                    .inset(by: Metrics.viewBorderInset)
                    .stroke(
                        isFocused ? .cheffiGray9 : .cheffiGray3,
                        lineWidth: Metrics.viewBorderWidth
                    )
            )
        }
        .padding(.top, Metrics.outerHStackPadding)
    }
}

struct TextEditorView_Preview: PreviewProvider {
    static var previews: some View {
        TextEditorView(
            Store(initialState: TextEditorViewReducer.State(
                txt: "",
                placeHolder: "음식의 맛, 양, 포장 상태 등 음식에 대한 솔직한 리뷰를 남겨주세요.",
                minCount: 100
            )) {
                TextEditorViewReducer()._printChanges()
            }
        )
    }
}
