//
//  SNSLoginViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit

class SNSLoginViewController: UIViewController {
    static func instance<T: SNSLoginViewController>(viewModel: SNSLoginViewModelType) -> T {
        let vc: T = .instance(storyboardName: .SNSLogin)
        vc.viewModel = viewModel
        return vc
    }
    
    private var viewModel: SNSLoginViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    deinit {
#if DEBUG
        print("SNSLoginViewController deinitialized")
#endif
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
        viewModel.showProfileSetup()
    }
}
