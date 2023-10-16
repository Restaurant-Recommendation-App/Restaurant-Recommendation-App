//
//  RestaurantContentItemType.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/13.
//

import Foundation

enum RestaurantContentItemType {
    case main
    case oneColumn
    case twoColumn
    
    var titleSize: CGFloat {
        switch self {
        case .main: return 18
        case .oneColumn: return 18
        case .twoColumn: return 16
        }
    }
    
    var contentHeight: Int {
        switch self {
        case .main: return 200
        case .oneColumn: return 361
        case .twoColumn: return 165
        }
    }
    
    var numberOfLines: Int {
        switch self {
        case .main: return 1
        case .oneColumn: return 1
        case .twoColumn: return 2
        }
    }
}
