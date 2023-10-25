//
//  CheffiRecommendationCategoryPageCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/18.
//

import UIKit
import Combine

final class CheffiRecommendationCategoryPageCell: UICollectionViewCell {
        
    private let popularRestaurantContentsView = CheffiRecommendationContensView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        popularRestaurantContentsView.isScrollEnabled = true
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
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(viewModel: RestaurantContentsViewModel) {
        popularRestaurantContentsView.configure(
            viewModel: viewModel
        )
    }
}

