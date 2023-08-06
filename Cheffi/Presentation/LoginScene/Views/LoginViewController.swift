//
//  LoginViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit

class LoginViewController: UIViewController {
    static func instance<T: LoginViewController>(viewModel: LoginViewModel) -> T {
        let vc: T = .instance(storyboardName: .login)
        vc.viewModel = viewModel
        return vc
    }
    
    private var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private
    private func setupViews() {
        
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @IBAction private func didTapClose(_ sender: UIButton) {
        self.dismissOne()
    }
    
    @IBAction private func didTapLogin(_ sender: UIButton) {
        
    }
}
