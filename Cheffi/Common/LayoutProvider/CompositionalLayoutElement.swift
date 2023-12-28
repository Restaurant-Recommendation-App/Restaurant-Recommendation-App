//
//  CompositionalLayoutElement.swift
//  Cheffi
//
//  Created by RONICK on 2023/11/13.
//

import UIKit

protocol CompositionalLayoutElement {
    var size: NSCollectionLayoutSize { get }
    var contentInsets: NSDirectionalEdgeInsets { get }
}
