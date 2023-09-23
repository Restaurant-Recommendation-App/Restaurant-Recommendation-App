//
//  PreferenceViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class PreferenceViewController: UIViewController {
    static func instance<T: PreferenceViewController>() -> T {
        let vc: T = .instance(storyboardName: .preference)
        return vc
    }
    
    @IBOutlet private weak var nextButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nickname = UserDefaultsManager.AuthInfo.user?.name ?? ""
        titleLabel.text = "\(nickname) 쉐피님,\n쉐피님의 취향을 선택해주세요.".localized()
    }
    
    // MARK: - Private
    private func setupViews() {
        nextButton.setTitle("다음".localized(), for: .normal)
        nextButton.didTapButton = { [weak self] in
            self?.delegate?.didTapNext()
        }
        
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.weight600.size(24)
        
        let subTitleFont = Fonts.suit.weight600.size(15)
        subTitleLabel.highlightKeyword("5가지".localized(), in: "5가지 이상 선택해주세요".localized(),
                                       defaultColor: .cheffiGray6,
                                       font: subTitleFont, keywordFont: subTitleFont)
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
}
