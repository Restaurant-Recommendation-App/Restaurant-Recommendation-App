//
//  AllCheffiContentsVCTopBar.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/11.
//

import UIKit
import SnapKit
import Combine

class AllCheffiContentsVCTopBar: UIView {
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icBack"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let titleButton: UIButton = {
        let button = UIButton()
        let title = UserDefaultsManager.AreaInfo.area.province + " " + UserDefaultsManager.AreaInfo.area.city
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.cheffiWhite, for: .normal)
        button.titleLabel?.font = Fonts.suit.weight500.size(16)
        button.titleLabel?.textAlignment = .center
        
        button.setNeedsUpdateConfiguration()
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        config.baseBackgroundColor = .cheffiBlack
        button.configuration = config
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
    
    var backButtonTapped: AnyPublisher<Void, Never> {
        backButton.controlPublisher(for: .touchUpInside)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    var titleButtonTapped: AnyPublisher<Void, Never> {
        titleButton.controlPublisher(for: .touchUpInside)
            .map { _ in () }
            .eraseToAnyPublisher()
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
    
    func setUpTitle(with areaTitle: String) {
        titleButton.setTitle(areaTitle, for: .normal)
    }
}
