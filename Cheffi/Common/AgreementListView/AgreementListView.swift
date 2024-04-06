//
//  AgreementListView.swift
//  Cheffi
//
//  Created by ronick on 2024/04/06.
//

import SwiftUI

struct AgreementListView: View {
    var body: some View {
        LazyVStack(spacing: 4) {
            ForEach(0 ..< 5) { number in
                HStack {
                    Button {
                        // TODO: 액션 이벤트
                    } label: {
                        Image("icUncheck")
                            .renderingMode(.original)
                            .tint(.cheffiGray2)
                    }
                    .padding(10)
                    
                    Text("[필수] 위치정보 이용동의 및 위치기반 서비스 이용 동의")
                        .multilineTextAlignment(.leading)
                        .font(
                            Font.custom("SUIT", size: 15)
                                .weight(.regular)
                        )
                        .foregroundStyle(.cheffiGray9)
                        .padding(.leading, 4)
                    
                    Spacer()
                    
                    Button {
                        // TODO: 액션 이벤트
                    } label: {
                        Image("icMoreRight")
                            .renderingMode(.template)
                            .tint(.cheffiGray4)
                    }
                }
                .padding([.top, .bottom], 12)
            }
        }
    }
}

#Preview {
    AgreementListView()
}
