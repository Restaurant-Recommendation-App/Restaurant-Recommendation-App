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
