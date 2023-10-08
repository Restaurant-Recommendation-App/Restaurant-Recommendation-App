//
//  PopularRestaurantContentsCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/09/06.
//

import UIKit
import SnapKit

final class PopularRestaurantContentsCell: UICollectionViewCell {
    private enum Constants {
        static let cellInset = 16
    }
    
    private let contentsItemView = PopularRestaurantContentsItemView()
    
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

        insetWrppingView.addSubview(contentsItemView)
        contentsItemView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.cellInset)
        }
    }
    
    func configure(viewModel: PopularRestaurantContentsItemView.ViewModel) {
        contentsItemView.configure(viewModel: viewModel)
    }
}
