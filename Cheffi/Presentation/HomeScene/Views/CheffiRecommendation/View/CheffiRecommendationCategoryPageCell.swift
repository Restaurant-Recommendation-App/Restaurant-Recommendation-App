//
//  CheffiRecommendationCategoryPageCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/18.
//

import UIKit
import Combine

final class CheffiRecommendationCategoryPageCell: UICollectionViewCell {
    
    enum Constants {
        static let cellInset = 16
    }
    
    let popularRestaurantContentsView = PopularRestaurantContentsView()
    
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
            $0.leading.trailing.equalToSuperview().inset(Constants.cellInset)
        }
    }
    
    func configure(viewModel: RestaurantContentsViewModel) {
        popularRestaurantContentsView.configure(
            viewModel: viewModel
        )
    }
}

