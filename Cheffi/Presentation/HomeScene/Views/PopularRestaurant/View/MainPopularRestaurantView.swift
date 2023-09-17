//
//  MainPopularRestaurantView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit
import Combine


class MainPopularRestaurantView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인기 급등 맛집"
        label.font = Fonts.suit.weight700.size(20)
        label.textColor = .cheffiBlack
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cheffiBlack
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var exclamationButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "icExclamationMark.circle")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tappedExclamation), for: .touchUpInside)
        return button
    }()
    
    private let moreContentsButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체보기   >", for: .normal)
        button.setTitleColor(UIColor.cheffiGray6, for: .normal)
        button.titleLabel?.font = Fonts.suit.weight500.size(14)
        return button
    }()
        
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
            $0.leading.bottom.equalToSuperview()
        }
        
        addSubview(exclamationButton)
        exclamationButton.snp.makeConstraints {
            $0.leading.equalTo(subtitleLabel.snp.trailing).offset(4)
            $0.bottom.equalTo(subtitleLabel)
        }
        
        addSubview(moreContentsButton)
        moreContentsButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(subtitleLabel)
            $0.height.equalTo(20)
        }
    }
    
    private func getSubtitleAttributedString() -> NSAttributedString {
        
        let icClockAttachment = NSTextAttachment()
        let icClockImg = UIImage(named: "icClock")
        icClockAttachment.image = icClockImg
        icClockAttachment.bounds = CGRect(x: 0, y: -2, width: icClockImg!.size.width, height: icClockImg!.size.height)
        let icClockString = NSAttributedString(attachment: icClockAttachment)
        
        let str1 = "  00 : 13 : 43"
        let color1 = UIColor.main
        let font1 = Fonts.suit.weight800.size(18)
        
        let str2 = " 초 뒤에\n인기 급등 맛집이 변경돼요."
        let color2 = UIColor.cheffiBlack
        let font2 = Fonts.suit.weight400.size(18)
        
        let combination = NSMutableAttributedString()
        
        let attr1 = [NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font: font1]
        let part1 = NSMutableAttributedString(string: str1, attributes: attr1 as [NSAttributedString.Key : Any])
        
        let attr2 = [NSAttributedString.Key.foregroundColor: color2, NSAttributedString.Key.font: font2]
        let part2 = NSMutableAttributedString(string: str2, attributes: attr2)
        
        combination.append(icClockString)
        combination.append(part1)
        combination.append(part2)
        
        return combination
    }
    
    @objc private func tappedExclamation() {
        print("tappedExclamation")
    }
}

