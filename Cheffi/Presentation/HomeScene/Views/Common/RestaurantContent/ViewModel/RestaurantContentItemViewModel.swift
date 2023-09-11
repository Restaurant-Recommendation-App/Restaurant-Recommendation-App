//
//  RestaurantContentItemViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/29.
//

import Foundation

struct RestaurantContentItemViewModel: Hashable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let title: String
    let subtitle: String
    
    init(content: Content) {
        self.id = content.id
        self.title = content.title
        self.subtitle = content.subtitle
    }
}
