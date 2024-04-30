//
//  MenuTabBarView.swift
//  Cheffi
//
//  Created by 김문옥 on 4/20/24.
//

import SwiftUI

struct MenuTabBarView: View {
    @Binding var currentTabIndex: Int
    @Namespace var namespace
    let tabBarItemNames: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(zip(tabBarItemNames.indices, tabBarItemNames)), id: \.0) { index, name in
                MenuTabBarItem(
                    currentTabIndex: $currentTabIndex,
                    namespace: namespace.self,
                    name: name,
                    tabIndex: index
                )
            }
        }
        .frame(height: 40.0)
    }
}

#Preview {
    @State var currentTabIndex: Int = 0
    return MenuTabBarView(
        currentTabIndex: $currentTabIndex,
        tabBarItemNames: [
            "내 리뷰",
            "니 리뷰",
            "우리 리뷰"
        ]
    )
}
