//
//  UICollectionView+Extensions.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/23.
//

import UIKit

extension UICollectionView {
    var visibleIndexPath: IndexPath? {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = indexPathForItem(at: visiblePoint)
        
        return visibleIndexPath
    }
}

