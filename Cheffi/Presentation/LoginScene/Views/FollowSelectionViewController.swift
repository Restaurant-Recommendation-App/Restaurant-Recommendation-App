//
//  FollowSelectionViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class FollowSelectionViewController: UIViewController {
    static func instance<T: FollowSelectionViewController>() -> T {
        let vc: T = .instance(storyboardName: .followSelection)
        return vc
    }
    
    @IBOutlet private weak var startButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        startButton.setTitle("시작하기")
        startButton.setBaackgroundColor(.main)
        startButton.didTapButton = { [weak self] in
            self?.delegate?.didTapNext()
        }
        
        titleLabel.text = "같은 취향을 가진\n쉐피를 팔로우 해보세요.".localized()
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.medium.size(24)
        
        subTitleLabel.text = "취향이 같은 쉐피들의 PICK을 확인해보세요!".localized()
        subTitleLabel.textColor = .cheffiGray6
        subTitleLabel.font = Fonts.suit.medium.size(15)
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
}
