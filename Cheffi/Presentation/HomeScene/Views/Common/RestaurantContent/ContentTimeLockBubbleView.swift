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
        label.text = "00:30:25"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
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
        backgroundColor = .black.withAlphaComponent(0.32)
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
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}
