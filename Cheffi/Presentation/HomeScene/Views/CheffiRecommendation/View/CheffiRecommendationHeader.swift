//
//  CheffiRecommendationHeader.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/08.
//

import UIKit

final class CheffiRecommendationHeader: UITableViewHeaderFooterView {
    private enum Constants {
        static let cellInset: CGFloat = 16.0
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "쉐피들의 인정 맛집"
        label.font = Fonts.suit.weight700.size(20)
        label.textColor = .cheffiBlack
        return label
    }()
        
    private let exclamationButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "icExclamationMark.circle")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var categoryTabView = CategoryTabView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .cheffiWhite
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(48)
            $0.leading.equalToSuperview().inset(Constants.cellInset)
        }
        
        contentView.addSubview(exclamationButton)
        exclamationButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.bottom.equalTo(titleLabel)
        }
        
        contentView.addSubview(categoryTabView)
        categoryTabView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
    }
    
    func configure(categoryTabViewDelegate: CategoryTabViewDelegate) {
        categoryTabView.delegate = categoryTabViewDelegate
    }
    
    func setUpTabTitles(titles: [String]) {
        categoryTabView.setUpTags(tags: titles)
    }
}
