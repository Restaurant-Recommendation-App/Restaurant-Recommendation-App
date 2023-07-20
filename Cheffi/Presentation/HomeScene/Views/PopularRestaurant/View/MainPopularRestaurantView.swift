//
//  MainPopularRestaurantView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit
import Combine


class MainPopularRestaurantView: UIView {
    
    enum Constants {
        static let inset = 16
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인기 급등 맛집"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let restaurantContentView = RestaurantContentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        subtitleLabel.attributedText = getSubtitleAttributedString()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(restaurantContentView)
        restaurantContentView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func getSubtitleAttributedString() -> NSAttributedString {
        let str1 = "00 : 13 : 43"
        let color1 = UIColor(hexString: "D82231")
        let font1 = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let str2 = " 초 뒤에\n인기 급등 맛집이 변경돼요."
        let color2 = UIColor.black
        let font2 = UIFont.systemFont(ofSize: 18, weight: .light)

        let combination = NSMutableAttributedString()
        
        let attr1 = [NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font: font1]
        let part1 = NSMutableAttributedString(string: str1, attributes: attr1 as [NSAttributedString.Key : Any])
        
        let attr2 = [NSAttributedString.Key.foregroundColor: color2, NSAttributedString.Key.font: font2]
        let part2 = NSMutableAttributedString(string: str2, attributes: attr2)
        
        combination.append(part1)
        combination.append(part2)
        
        return combination
    }
}

