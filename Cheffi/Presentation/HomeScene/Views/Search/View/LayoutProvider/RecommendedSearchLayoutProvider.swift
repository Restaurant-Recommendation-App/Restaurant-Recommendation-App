//
//  RecommendedSearchLayoutProvider.swift
//  Cheffi
//
//  Created by RONICK on 2023/11/26.
//

import UIKit

struct RecommendedSearchLayoutProvider: SectionLayoutProvidable {
    var itemLayout: ItemLayout {
        let size: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .fractionalHeight(1)
        )
        
        return ItemLayout(
            size: size,
            contentInsets: .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        )
    }
    
    var groupLayout: GroupLayout {
        let size: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(RecommendedSearchCell.Constants.contentHeight)
        )
        
        return GroupLayout(
            size: size,
            contentInsets: .init(top: 0, leading: 0, bottom: 0, trailing: 0),
            scrollDirection: .horizontal
        )
    }
    
    func getLayoutSection() -> NSCollectionLayoutSection {
        let group = getGroup()
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 8
        
        let supplementaryLayout = CollectionSupplementaryLayout()
        section.boundarySupplementaryItems = [supplementaryLayout.getSectionHeader()]
        return section
    }
}
