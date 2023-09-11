//
//  RestaurantContentView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit
import SnapKit
import Combine

class RestaurantContentView: UIView {
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hexString: "EAEAEA")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let contentTimeLockBubbleView = ContentTimeLockBubbleView()
    
    private let restaurantTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그시절낭만의 근본 경양식 돈가스"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .cheffiBlack
        label.numberOfLines = 2
        return label
    }()
    
    private let restaurantSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "짬뽕 외길의 근본이 느껴 지는 중식당짬뽕"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .cheffiGray7
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icDisLike"), for: .normal)
        button.setImage(UIImage(named: "icLike"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        
        addSubview(restaurantImageView)
        restaurantImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        addSubview(contentTimeLockBubbleView)
        contentTimeLockBubbleView.snp.makeConstraints {
            $0.top.equalTo(restaurantImageView).offset(12)
            $0.trailing.equalTo(restaurantImageView).inset(8)
            $0.width.equalTo(87)
            $0.height.equalTo(32)
        }
        
        addSubview(restaurantTitleLabel)
        restaurantTitleLabel.snp.makeConstraints {
            $0.top.equalTo(restaurantImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        addSubview(restaurantSubtitleLabel)
        restaurantSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(restaurantTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        addSubview(likeButton)
        likeButton.snp.makeConstraints {
            $0.top.equalTo(restaurantTitleLabel).offset(3)
            $0.leading.equalTo(restaurantTitleLabel.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    func configure(title: String, subtitle: String, isMainContent: Bool) {
        restaurantTitleLabel.text = title
        restaurantSubtitleLabel.text = subtitle
        
        if isMainContent {
            updateContent(titleSize: CGFloat(18), contentHeight: 200, numberOfLines: 1)
        } else {
            updateContent(titleSize: CGFloat(16), contentHeight: 165, numberOfLines: 2)
        }
    }
    
    private func updateContent(titleSize: CGFloat, contentHeight: CGFloat, numberOfLines: Int) {
        restaurantImageView.snp.updateConstraints {
            $0.height.equalTo(contentHeight)
        }
        
        restaurantTitleLabel.font = .systemFont(ofSize: titleSize, weight: .bold)
        restaurantTitleLabel.numberOfLines = numberOfLines
    }
    
    @objc private func likeButtonTapped() {
        likeButton.isSelected.toggle()
    }
}
