//
//  AgreementView.swift
//  Cheffi
//
//  Created by ronick on 2024/03/31.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(AgreementReducer.self)
struct AgreementView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {            
            NavigationBarView(store.scope(
                state: \.navigationBarState,
                action: AgreementReducer.Action.navigationBarAction
            ))
            
            Text("약관에 동의해주세요")
                .multilineTextAlignment(.leading)
                .font(
                    Font.custom("SUIT", size: 22)
                        .weight(.bold)
                )
                .foregroundColor(.cheffiGray8)
                .padding(16)
            
            HStack(alignment: .top, spacing: 8) {
                Button(action: {
                    viewStore.send(.consentAllAction)
                }, label: {
                    if viewStore.state.isAllConsented {
                        Image("icSelectedFill")
                    } else {
                        Image("icUnselectedFill")
                    }
                })
                .padding(10)
                
                VStack(alignment: .leading, spacing: 14) {
                    Text("약관 전체동의")
                        .multilineTextAlignment(.leading)
                        .font(
                            Font.custom("SUIT", size: 18)
                                .weight(.bold)
                        )
                        .foregroundColor(.cheffiGray8)
                        
                    Text("서비스 이용을 위해 다음의 약관에 모두 동의합니다.")
                        .multilineTextAlignment(.leading)
                        .font(
                            Font.custom("SUIT", size: 14)
                                .weight(.regular)
                        )
                        .foregroundColor(.cheffiGray4)
                }
                .padding(.top, 10)
            }
            .padding(.leading, 16)
            .padding(.top, 58)
            
            Divider()
                .padding(.top, 16)
            
            AgreementListView(store.scope(
                state: \.agreementListState,
                action: AgreementReducer.Action.tappedCheckBox
            ))
            .padding(.top, 24)
            .padding(.horizontal, 16)
            
            Spacer()
            
            BottomButtonView(
                store.scope(state: \.bottomButtonState, 
                            action: AgreementReducer.Action.bottomButtonAction
            ))
            .padding(.horizontal, 16)
        }
    }
}

struct AgreementView_Previews: PreviewProvider {
    static var previews: some View {
        AgreementView(Store(initialState: AgreementReducer.State()) {
            
        })
    }
}
