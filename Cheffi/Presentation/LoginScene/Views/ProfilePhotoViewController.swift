//
//  ProfilePhotoViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class ProfilePhotoViewController: UIViewController {
    static func instance<T: ProfilePhotoViewController>() -> T {
        let vc: T = .instance(storyboardName: .profilePhoto)
        return vc
    }
    
    @IBOutlet private weak var registerProfileButton: CustomProfileButton!
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        registerProfileButton.setTitle("프로필 등록하기")
        registerProfileButton.setBaackgroundColor(.main)
        registerProfileButton.didTapButton = { [weak self] in
            self?.delegate?.didTapNext()
        }
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
}
