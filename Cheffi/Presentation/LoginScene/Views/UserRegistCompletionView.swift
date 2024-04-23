//
//  UserRegistCompletionView.swift
//  Cheffi
//
//  Created by ronick on 2024/04/16.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(UserRegistComplReducer.self)
struct UserRegistCompletionView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("UserRegistCompletion")
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.top, 171)
            
            Text("가입 완료!")
                .font(Font.custom("SUIT", size: 24)
                    .weight(.medium)
                )
                .foregroundColor(.cheffiGray9)
                .padding(.top, 20)
            
            Text("쉐피에 오신걸 환영합니다")
                .font(Font.custom("SUIT", size: 24)
                    .weight(.regular)
                )
                .foregroundColor(.cheffiGray9)
                .padding(.top, 0)
            
            Text("게시물 작성 및 맛집 조회를 위해\n프로필 등록이 필요해요")
                .multilineTextAlignment(.center)
                .font(Font.custom("SUIT", size: 15)
                    .weight(.thin)
                )
                .foregroundColor(.cheffiGray7)
                .padding(.top, 16)
            
            Spacer()
                        
            BottomButtonView(
                store.scope(state: \.bottomButtonState,
                            action: UserRegistComplReducer.Action.profileSetupButtonAction)
            )
            .padding(.horizontal, 8)
            
            Button {
                viewStore.send(.homeButtonAction)
            } label: {
                Text("둘러보기")
                    .font(Font.custom("SUIT", size: 16)
                        .weight(.bold)
                    )
                    .foregroundColor(.cheffiGray4)
                    .underline()
            }
        }.ignoresSafeArea(.keyboard)
    }
}

struct UserRegistCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        UserRegistCompletionView(
            Store(initialState: UserRegistComplReducer.State()) {
                
            }
        )
    }
}
