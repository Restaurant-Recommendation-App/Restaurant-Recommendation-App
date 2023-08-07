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
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
}
