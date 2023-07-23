//
//  CheffiRecommendationCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/18.
//

import UIKit

final class CheffiRecommendationCell: UITableViewCell {
    
    enum Constants {
        static let cellTopInset: CGFloat = 48
        static let cellInset: CGFloat = 16.0
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "쉐피들의 인정 맛집"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "‘맛있어요’ 투표율이 높아요!"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hexString: "636363")
        label.numberOfLines = 2
        return label
    }()
    
    private let viewMoreContentsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("더보기", for: .normal)
        button.titleLabel?.textAlignment = .center

        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexString: "E2E2E2")?.cgColor
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    private let categoryTabView = CategoryTabView()
    
    private let cheffiRecommendationCatogoryPageView = CheffiRecommendationCategoryPageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setUp()
        categoryTabView.setUpCategories(categories: ["한식", "양식", "중식", "일식", "퓨전", "샐러드"])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: Constants.cellTopInset, left: 0, bottom: Constants.cellInset, right: 0)
        )
    }
    
    private func setUp() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.cellInset)
        }
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(Constants.cellInset)
        }
        
        contentView.addSubview(categoryTabView)
        categoryTabView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        contentView.addSubview(cheffiRecommendationCatogoryPageView)
        cheffiRecommendationCatogoryPageView.snp.makeConstraints {
            $0.top.equalTo(categoryTabView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(550)
        }
        
        contentView.addSubview(viewMoreContentsButton)
        viewMoreContentsButton.snp.makeConstraints {
            $0.top.equalTo(cheffiRecommendationCatogoryPageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(Constants.cellInset)
            $0.height.equalTo(40)
        }
    }
}
