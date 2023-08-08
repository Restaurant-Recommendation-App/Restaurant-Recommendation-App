//
//  NicknameViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class NicknameViewController: UIViewController {
    static func instance<T: NicknameViewController>() -> T {
        let vc: T = .instance(storyboardName: .nickname)
        return vc
    }
    
    @IBOutlet private weak var nextButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var duplicationCheckButton: UIButton!
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        nextButton.setTitle("다음")
        nextButton.setBaackgroundColor(.main)
        nextButton.didTapButton = { [weak self] in
            self?.delegate?.didTapNext()
        }
        
        titleLabel.text = "쉐피에서 사용할\n닉네임을 입력해주세요.".localized()
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.medium.size(24)
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
    @IBAction private func duplicationCheck(_ sender: UIButton) {
        
    }
}
