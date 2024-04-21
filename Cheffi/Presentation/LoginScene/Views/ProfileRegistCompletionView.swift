//
//  ProfileRegistCompletionView.swift
//  Cheffi
//
//  Created by ronick on 2024/04/19.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(ProfileRegistCompleReducer.self)
struct ProfileRegistCompletionView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("empty_menu_background")
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.top, 176
                )
            
            Text("김맛집님 환영해요")
                .font(
                    Font.custom("SUIT", size: 24)
                        .weight(.medium)
                )
                .foregroundColor(.cheffiGray9)
                .padding(.top, 32)
            
            Text("쉐피를 즐길 준비가 끝났어요!")
                .font(Font.custom("SUIT", size: 24)
                    .weight(.regular)
                )
                .foregroundColor(.cheffiGray9)
                .padding(.top, 0)
            
            Text("이제 쉐피에서 나만의 맛집을 소개하고\n나에게 맞는 맛집을 찾아볼 수 있어요\n다른 쉐피들과 함께 전국의 맛을 탐구해보세요")
                .multilineTextAlignment(.center)
                .font(
                    Font.custom("SUIT", size: 15)
                        .weight(.thin)
                )
                .foregroundColor(.cheffiGray7)
                .padding(.top, 16)
            
            Spacer()
            
            BottomButtonView(
                store.scope(state: \.bottomButtonState, action: ProfileRegistCompleReducer.Action.startButtonAction)
            )
            .padding(.horizontal, 8)
        }
    }
}

struct ProfileRegistCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRegistCompletionView(
            Store(initialState: ProfileRegistCompleReducer.State()) {
                
            }
        )
    }
}
