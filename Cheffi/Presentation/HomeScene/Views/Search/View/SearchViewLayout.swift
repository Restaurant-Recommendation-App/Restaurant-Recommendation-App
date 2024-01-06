//
//  SearchViewLayout.swift
//  Cheffi
//
//  Created by RONICK on 2023/11/13.
//

import UIKit

enum SearchSectionType: Int {
    case recentSearch = 0
    // TODO: 이번 mvp 에서는 추천 검색어는 제외되었으므로 제거 필요
    case recommendedSearch
    
    var headerTitle: String {
        switch self {
        case .recentSearch:
            return "최근 검색어"
        case .recommendedSearch:
            return "추천 검색어"
        }
    }

}

struct SearchViewLayout {
    func getCollectionViewSectionLayout(withSection section: Int) -> NSCollectionLayoutSection {
        switch SearchSectionType(rawValue: section) {
        case .recentSearch:
            return RecentSearchLayoutProvider().getLayoutSection()
        case .recommendedSearch:
            return RecommendedSearchLayoutProvider().getLayoutSection()
        default:
            return RecentSearchLayoutProvider().getLayoutSection()
        }
    }
}
