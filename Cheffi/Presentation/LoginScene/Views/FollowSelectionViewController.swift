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
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
}
