//
//  ContentLockTimeBubbleView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit
import SnapKit

class ContentTimeLockBubbleView: UIView {
    
    private let timeLockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icContentTimeLock")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let timeLockLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = Fonts.suit.weight600.size(14)
        label.textColor = .cheffiWhite
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpBackground()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpBackground() {
        backgroundColor = .cheffiBlack.withAlphaComponent(0.32)
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    private func setUp() {
        addSubview(timeLockImageView)
        timeLockImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(16)
        }
        
        addSubview(timeLockLabel)
        timeLockLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(42)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    private func setTimeLock(timeString: String, color: UIColor) {
        timeLockLabel.text = timeString
        timeLockLabel.textColor = color
        timeLockImageView.image = UIImage(named: "icContentTimeLock")?
            .withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    func updateTimeLock(timeLockType: TimeLockType) {
        let timerString: String
        let color: UIColor
        
        switch timeLockType {
        case .lock(let lockString):
            timerString = lockString
            color = .cheffiWhite
            timeLockLabel.snp.updateConstraints {
                $0.width.equalTo(67)
            }
        case .unlock(let digits):
            timerString = digits
            color = .cheffiWhite
            timeLockLabel.snp.updateConstraints {
                $0.width.equalTo(42)
            }
        case .willLock(let digits):
            timerString = digits
            color = .main
            timeLockLabel.snp.updateConstraints {
                $0.width.equalTo(62)
            }
        }
        
        setTimeLock(timeString: timerString, color: color)
    }
}
