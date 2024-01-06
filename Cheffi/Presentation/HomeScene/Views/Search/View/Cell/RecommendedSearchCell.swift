//
//  RecommendedSearchCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/11/27.
//

import UIKit
import SnapKit

class RecommendedSearchCell: UICollectionViewCell {
    enum Constants {
        static let contentHeight: CGFloat = 32
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 6
    }
    
    private lazy var searchTagView: UIView = {
        let view = UIView()
        view.addSubview(title)
        view.backgroundColor = .cheffiPink2
        
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = Fonts.suit.weight500.size(15)
        label.textColor = .main
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        contentView.addSubview(searchTagView)
        
        searchTagView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(0)
            $0.height.equalTo(0)
        }
        
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Constants.horizontalPadding)
        }
    }
    
    func update(title: String) {
        self.title.text = title
        
        let size = title.size(withAttributes: [NSAttributedString.Key.font : Fonts.suit.weight500.size(15)])
        let width = size.width + Constants.horizontalPadding * 2
        let height = size.height + Constants.verticalPadding * 2
        
        searchTagView.snp.updateConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
    }
}
