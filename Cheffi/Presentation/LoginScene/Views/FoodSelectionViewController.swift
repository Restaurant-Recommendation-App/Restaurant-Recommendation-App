//
//  FoodSelectionViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class FoodSelectionViewController: UIViewController {
    static func instance<T: FoodSelectionViewController>() -> T {
        let vc: T = .instance(storyboardName: .foodSelection)
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
    
    // MARK: - Private
    private func setupViews() {
        nextButton.setTitle("다음")
        nextButton.didTapButton = { [weak self] in
            self?.delegate?.didTapNext()
        }
        
        let nickname = "김맛집"
        titleLabel.text = "\(nickname) 쉐피님,\n좋아하는 음식을 선택해주세요.".localized()
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.medium.size(24)
        
        subTitleLabel.highlightKeyword("3가지".localized(), in: "3가지 이상 선택해주세요".localized(),
                                       defaultColor: .cheffiGray6, font: Fonts.suit.medium.size(15))
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
}
