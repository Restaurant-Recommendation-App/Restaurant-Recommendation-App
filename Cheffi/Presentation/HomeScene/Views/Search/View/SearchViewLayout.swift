//
//  SearchViewLayout.swift
//  Cheffi
//
//  Created by RONICK on 2023/11/13.
//

import UIKit

enum SearchCellType: Int {
    case recentSearch = 0
    case recommendedSearch
}

struct SearchViewLayout {
    func getCollectionViewSectionLayout(withSection section: Int) -> NSCollectionLayoutSection {
        switch SearchCellType(rawValue: section) {
        case .recentSearch:
            return RecentSearchLayoutProvider().getLayoutSection()
        case .recommendedSearch:
            return RecommendedSearchLayoutProvider().getLayoutSection()
        default:
            return RecentSearchLayoutProvider().getLayoutSection()
        }
    }
}
