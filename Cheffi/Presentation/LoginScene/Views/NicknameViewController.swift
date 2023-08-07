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
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
}
