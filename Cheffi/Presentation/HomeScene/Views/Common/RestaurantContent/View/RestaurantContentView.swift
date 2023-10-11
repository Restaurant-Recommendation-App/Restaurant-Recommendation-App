//
//  RestaurantContentView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit
import SnapKit
import Combine

enum RestaurantContentItemType {
    case main
    case oneColumn
    case twoColumn
}

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
        label.font = Fonts.suit.weight700.size(16)
        label.textColor = .cheffiBlack
        label.numberOfLines = 2
        return label
    }()
    
    private let restaurantSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "짬뽕 외길의 근본이 느껴 지는 중식당짬뽕"
        label.font = Fonts.suit.weight400.size(15)
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
        addSubview(contentTimeLockBubbleView)
        addSubview(restaurantTitleLabel)
        addSubview(restaurantSubtitleLabel)
        addSubview(likeButton)
        updateContent(itemType: .twoColumn)
    }
    
    func configure(title: String, subtitle: String, timeLockType: TimeLockType, itemType: RestaurantContentItemType) {
        restaurantTitleLabel.text = title
        restaurantSubtitleLabel.text = subtitle
        updateTimer(timeLockType: timeLockType)
        updateContent(itemType: itemType)
    }

    func updateTimer(timeLockType: TimeLockType) {
        contentTimeLockBubbleView.snp.updateConstraints {
            switch timeLockType {
            case .lock(_):
                $0.width.equalTo(115)
            case .unlock(_):
                $0.width.equalTo(90)
            case .willLock:
                $0.width.equalTo(110)
            }
        }
        contentTimeLockBubbleView.updateTimeLock(timeLockType: timeLockType)
    }
    
    private func updateContent(itemType: RestaurantContentItemType) {
        var titleSize: CGFloat
        var contentHeight: Int
        var numberOfLines: Int
        
        switch itemType {
        case .main:
            titleSize = 18
            contentHeight = 200
            numberOfLines = 1
        case .oneColumn:
            titleSize = 18
            contentHeight = Int(bounds.width)
            numberOfLines = 1
        case .twoColumn:
            titleSize = 16
            contentHeight = 165
            numberOfLines = 2
        }
        restaurantTitleLabel.font = .systemFont(ofSize: titleSize, weight: .bold)
        restaurantTitleLabel.numberOfLines = numberOfLines
        
        restaurantImageView.snp.remakeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.width.equalTo(contentHeight)
        }
        
        contentTimeLockBubbleView.snp.makeConstraints {
            $0.top.equalTo(restaurantImageView).offset(12)
            $0.trailing.equalTo(restaurantImageView).inset(8)
            $0.width.equalTo(90)
            $0.height.equalTo(32)
        }
        
        if itemType == .oneColumn {
            restaurantTitleLabel.snp.remakeConstraints {
                $0.top.equalTo(restaurantImageView.snp.bottom).offset(12)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(26)
            }
            
            restaurantSubtitleLabel.snp.remakeConstraints {
                $0.top.equalTo(restaurantTitleLabel.snp.bottom).offset(8)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(22)
            }
            
            likeButton.snp.remakeConstraints {
                $0.top.equalTo(restaurantSubtitleLabel.snp.bottom).offset(16)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(24)
                $0.bottom.equalToSuperview()
            }
            
        } else {
            restaurantTitleLabel.snp.remakeConstraints {
                $0.top.equalTo(restaurantImageView.snp.bottom).offset(12)
                $0.leading.equalToSuperview()
                $0.height.equalTo(itemType == .twoColumn ? 40 : 26)
            }
            
            restaurantSubtitleLabel.snp.remakeConstraints {
                $0.top.equalTo(restaurantTitleLabel.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            
            likeButton.snp.remakeConstraints {
                $0.top.equalTo(restaurantTitleLabel).offset(3)
                $0.leading.equalTo(restaurantTitleLabel.snp.trailing)
                $0.trailing.equalToSuperview()
                $0.width.height.equalTo(24)
            }
        }
    }
        
    @objc private func likeButtonTapped() {
        likeButton.isSelected.toggle()
    }
}
