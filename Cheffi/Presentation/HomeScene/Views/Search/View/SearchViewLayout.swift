//
//  SearchViewLayout.swift
//  Cheffi
//
//  Created by RONICK on 2023/11/13.
//

import UIKit

enum SearchCellType: Int {
    case recentSearch = 0
    // TODO: 이번 mvp 에서는 추천 검색어는 제외되었으므로 제거 필요
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
