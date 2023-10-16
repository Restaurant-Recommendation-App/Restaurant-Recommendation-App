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
    
    private let subtitleTimerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cheffiBlack
        return label
    }()
    
    private let subtitleLabel01: UILabel = {
        let label = UILabel()
        label.textColor = .cheffiBlack
        label.text = "초 뒤에"
        label.font = Fonts.suit.weight400.size(18)
        return label
    }()
    
    private let subtitleLabel02: UILabel = {
        let label = UILabel()
        label.textColor = .cheffiBlack
        label.text = "인기 급등 맛집이 변경돼요."
        label.font = Fonts.suit.weight400.size(18)
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
    
    private let allContentsButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체보기   >", for: .normal)
        button.setTitleColor(UIColor.cheffiGray6, for: .normal)
        button.titleLabel?.font = Fonts.suit.weight500.size(14)
        return button
    }()
    
    var allContentsButtonTapped: UIControl.EventPublisher {
        allContentsButton.controlPublisher(for: .touchUpInside)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        subtitleTimerLabel.attributedText = getTimerAttributedString(timerString: "00:00:00")
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
        
        addSubview(subtitleTimerLabel)
        subtitleTimerLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.width.equalTo(110)
        }
        
        addSubview(subtitleLabel01)
        subtitleLabel01.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(subtitleTimerLabel.snp.trailing)
        }
        
        addSubview(subtitleLabel02)
        subtitleLabel02.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel01.snp.bottom)
            $0.leading.equalToSuperview()
        }
        
        addSubview(exclamationButton)
        exclamationButton.snp.makeConstraints {
            $0.leading.equalTo(subtitleLabel02.snp.trailing).offset(4)
            $0.bottom.equalTo(subtitleLabel02)
        }
        
        addSubview(allContentsButton)
        allContentsButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(subtitleLabel02)
            $0.height.equalTo(20)
        }
    }
    
    func setTimerString(timerString: String) {
        subtitleTimerLabel.attributedText = getTimerAttributedString(timerString: timerString)
    }
    
    private func getTimerAttributedString(timerString: String) -> NSAttributedString {
        
        let icClockAttachment = NSTextAttachment()
        let icClockImg = UIImage(named: "icClock")
        icClockAttachment.image = icClockImg
        icClockAttachment.bounds = CGRect(x: 0, y: -2, width: icClockImg!.size.width, height: icClockImg!.size.height)
        let icClockString = NSAttributedString(attachment: icClockAttachment)
        
        let str1 = "  \(timerString)"
        let color1 = UIColor.main
        let font1 = Fonts.suit.weight800.size(18)
        
        let combination = NSMutableAttributedString()
        
        let attr1 = [NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font: font1]
        let part1 = NSMutableAttributedString(string: str1, attributes: attr1 as [NSAttributedString.Key : Any])
        
        combination.append(icClockString)
        combination.append(part1)
        
        return combination
    }
    
    @objc private func tappedExclamation() {
        print("tappedExclamation")
    }
}
