//
//  AllCheffiContentsVCTopBar.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/11.
//

import UIKit
import SnapKit

class AllCheffiContentsVCTopBar: UIView {
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icBack"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let titleButton: UIButton = {
        let button = UIButton()
        button.setTitle("서울시 성동구", for: .normal)
        button.setTitleColor(.cheffiWhite, for: .normal)
        button.titleLabel?.font = Fonts.suit.weight500.size(16)
        button.backgroundColor = .cheffiBlack
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icSearch"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icNotification"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var backButtonTapped: UIControl.EventPublisher {
        backButton.controlPublisher(for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpTitleButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        addSubview(titleButton)
        titleButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(108)
        }
        
        addSubview(notificationButton)
        notificationButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.trailing.equalTo(notificationButton.snp.leading)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(44)
        }
    }
    
    private func setUpTitleButton() {
        titleButton.layer.cornerRadius = 15
        titleButton.layer.masksToBounds = true
    }

}
