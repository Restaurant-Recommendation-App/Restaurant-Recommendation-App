//
//  TagItemButtonStyle.swift
//  Cheffi
//
//  Created by 김문옥 on 3/3/24.
//

import SwiftUI

struct TagItemButtonStyle: ButtonStyle {
    var isSelected = false

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(isSelected ? .mainCTA : .cheffiGray8)
            .background(
                RoundedRectangle(cornerRadius: 1000)
                    .inset(by: 0.5)
                    .stroke(isSelected ? .mainCTA : .cheffiGray2, lineWidth: 1)
            )
            .animation(.linear)
    }
}
