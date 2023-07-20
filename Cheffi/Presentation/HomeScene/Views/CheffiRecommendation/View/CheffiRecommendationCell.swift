//
//  CheffiRecommendationCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/18.
//

import UIKit

final class CheffiRecommendationCell: UITableViewCell {
    
    enum Constants {
        static let cellInset: CGFloat = 16.0
    }
    
    private let cheffiRecommendationCatogoryPageView = CheffiRecommendationCategoryPageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: Constants.cellInset, left: 0, bottom: Constants.cellInset, right: 0)
        )
    }
    
    private func setUp() {
        contentView.addSubview(cheffiRecommendationCatogoryPageView)
        cheffiRecommendationCatogoryPageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
}
