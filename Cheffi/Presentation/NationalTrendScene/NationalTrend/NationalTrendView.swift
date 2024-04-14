//
//  NationalTrendView.swift
//  Cheffi
//
//  Created by 김문옥 on 4/5/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(NationalTrendReducer.self)
struct NationalTrendView: View {
    var body: some View {
        ZStack {
            Color.cheffiDimmed
                .ignoresSafeArea()
            
            GeometryReader {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        HStack(alignment: .top, spacing: 16) {
                            Text("NATION\nWIDE\nTREND")
                                .font(.custom("SUIT", size: 32).weight(.black))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .underline()
                                .foregroundColor(.cheffiWhite)
                                .padding(EdgeInsets(top: 14, leading: 0, bottom: 12, trailing: 0))
                            
                            Button {
                                viewStore.send(.closeButtonTapped)
                            } label: {
                                Image("icClose")
                                    .renderingMode(.template)
                                    .tint(.cheffiWhite)
                                    .frame(width: 46, height: 46)
                            }
                        }
                        
                        Text("전국 쉐피가 인정한\n그 곳, 쉐피 전국 맛집")
                            .font(.custom("SUIT", size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.cheffiWhite)
                        
                        Text("COMING SOON")
                            .font(.custom("SUIT", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.cheffiWhite)
                            .padding(EdgeInsets(top: 166, leading: 16, bottom: 0, trailing: 16))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 10, leading: 16, bottom: 16, trailing: 16))
                    .background(content: {
                        ZStack {
                            Color.black
                            
                            VStack {
                                Spacer()
                                
                                Image("Coming_Soon")
                            }
                            .padding(.bottom, 16)
                        }
                    })
                    .cornerRadius(16.0)
                }
                .padding(.horizontal, 16.0)
                .frame(width: $0.size.width, height: $0.size.height)
            }
        }
    }
}

struct NationalTrendView_Preview: PreviewProvider {
    static var previews: some View {
        NationalTrendView(
            Store(initialState: NationalTrendReducer.State()) {
                NationalTrendReducer(
                    steps: PassthroughSubject<RouteStep, Never>()
                )._printChanges()
            }
        )
    }
}
