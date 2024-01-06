//
//  CollectionSupplementaryLayout.swift
//  Cheffi
//
//  Created by RONICK on 2023/11/26.
//

import UIKit

struct CollectionSupplementaryLayout {
    func getSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(20)
        )
        
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
    }
}
