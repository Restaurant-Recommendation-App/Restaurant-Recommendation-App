//
//  CheffiRecommendationCategoryPageCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/18.
//

import UIKit

final class CheffiRecommendationCategoryPageCell: UICollectionViewCell {
    
    private let popularRestaurantContentsView = PopularRestaurantContentsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        let insetWrppingView = UIView()
        
        contentView.addSubview(insetWrppingView)
        insetWrppingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        insetWrppingView.addSubview(popularRestaurantContentsView)
        popularRestaurantContentsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

