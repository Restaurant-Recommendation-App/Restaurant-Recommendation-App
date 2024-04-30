//
//  MenuTabBarItem.swift
//  Cheffi
//
//  Created by 김문옥 on 4/20/24.
//

import SwiftUI

struct MenuTabBarItem: View {
    @Binding var currentTabIndex: Int
    let namespace: Namespace.ID
    
    let name: String
    let tabIndex: Int
    
    var body: some View {
        Button {
            currentTabIndex = tabIndex
        } label: {
            VStack(spacing: 0) {
                Spacer()
                
                Text(name)
                    .font(
                        .custom("SUIT", size: 15)
                        .weight(currentTabIndex == tabIndex ? .semibold : .medium)
                    )
                    .foregroundColor(currentTabIndex == tabIndex ? .cheffiGray10 : .cheffiGray5)
                
                Spacer()
                
                if currentTabIndex == tabIndex {
                    Color.cheffiBlack
                        .frame(height: 2.0)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                } else {
                    Color.clear
                        .frame(height: 2.0)
                }
            }
            .animation(.spring(), value: currentTabIndex)
        }
    }
}

#Preview {
    @State var currentTabIndex: Int = 0
    @Namespace var namespace
    return MenuTabBarItem(
        currentTabIndex: $currentTabIndex, 
        namespace: namespace.self,
        name: "내 리뷰",
        tabIndex: 2
    )
}
