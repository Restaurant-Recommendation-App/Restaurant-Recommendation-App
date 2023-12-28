//
//  SearchViewHeader.swift
//  Cheffi
//
//  Created by RONICK on 2023/12/18.
//

import UIKit
import SnapKit

class SearchViewHeader: UICollectionReusableView {
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = Fonts.suit.weight700.size(16)
        label.textColor = .cheffiGray8
        
        return label
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        addSubview(title)
        title.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        self.title.text = title
    }
}
