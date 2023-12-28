//
//  RecentSearchLayoutProvider.swift
//  Cheffi
//
//  Created by RONICK on 2023/11/13.
//

import UIKit

struct RecentSearchLayoutProvider: SectionLayoutProvidable {
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
            widthDimension: .estimated(70),
            heightDimension: .absolute(RecentSearchCell.Constants.contentHeight)
        )
        
        return GroupLayout(
            size: size,
            contentInsets: .init(top: 0, leading: 0, bottom: 0, trailing: 0),
            scrollDirection: .horizontal
        )
    }
    
    func getLayoutSection() -> NSCollectionLayoutSection {        
        let section = NSCollectionLayoutSection(group: getGroup())
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 0)
        section.interGroupSpacing = 12
        
        let supplementaryLayout = CollectionSupplementaryLayout()
        section.boundarySupplementaryItems = [supplementaryLayout.getSectionHeader()]
        return section
    }
}
