//
//  SectionLayoutProvider.swift
//  Cheffi
//
//  Created by RONICK on 2023/11/13.
//

import UIKit

protocol SectionLayoutProvidable {
    var groupLayout: GroupLayout { get }
    var itemLayout: ItemLayout { get }
    
    func getLayoutSection() -> NSCollectionLayoutSection
}

extension SectionLayoutProvidable {
    func getGroup() -> NSCollectionLayoutGroup {
        var group: NSCollectionLayoutGroup
        
        if groupLayout.scrollDirection == .vertical {
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupLayout.size, subitems: [getLayoutItem()])
            group.contentInsets = groupLayout.contentInsets
            return group
        }
        
        group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayout.size, subitems: [getLayoutItem()])
        group.contentInsets = groupLayout.contentInsets
        
        return group
    }
    
    func getLayoutItem() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: itemLayout.size)
        item.contentInsets = itemLayout.contentInsets
        return item
    }
}
