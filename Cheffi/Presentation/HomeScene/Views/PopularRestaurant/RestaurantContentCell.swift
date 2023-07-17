//
//  RestaurantContentCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit

class RestaurantContentCell: UICollectionViewCell {
    
    private let restaurantContentView = RestaurantContentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = false
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        contentView.addSubview(restaurantContentView)
        restaurantContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(contentImageHeight: CGFloat, title: String, subtitle: String) {
        restaurantContentView.configure(
            contentImageHeight: contentImageHeight,
            title: title,
            subtitle: subtitle
        )
    }
}
