//
//  TagItemButton.swift
//  Cheffi
//
//  Created by 김문옥 on 3/3/24.
//

import SwiftUI

struct TagItemButton<Label>: View where Label: View {
    private let action: (() -> ())?
    private let label: (() -> Label)?
    @State var buttonStyle = TagItemButtonStyle()

    init(action: (() -> ())? = nil, label: (() -> Label)? = nil) {
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: {
            self.buttonStyle.isSelected = !self.buttonStyle.isSelected
            self.action?()
        }) {
            label?()
        }
        .buttonStyle(buttonStyle)
    }
}
