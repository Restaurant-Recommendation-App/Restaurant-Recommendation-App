//
//  NavigationBarView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/1/24.
//

import SwiftUI
import ComposableArchitecture

struct NavigationBarView: View {
    private enum Metrics {
        static let navigationBarViewHeight = 44.0
    }
    
    let title: String
    
    var body: some View {
        HStack {
            Text(self.title)
                .font(
                Font.custom("SUIT", size: 16)
                .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.cheffiBlack)
        }
        .frame(height: Metrics.navigationBarViewHeight)
    }
}

#Preview {
    NavigationBarView(title: "내 맛집 등록")
}
