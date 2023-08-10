//
//  RestaurantContentsViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/28.
//

import Foundation
import Combine

struct RestaurantContentsViewModel: Hashable, Identifiable {
    let id = UUID()
    
    var title: String
    var subtitle: String
    var contentImageHeight: Int
}
