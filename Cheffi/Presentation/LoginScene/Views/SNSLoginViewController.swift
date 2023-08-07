//
//  SNSLoginViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit

class SNSLoginViewController: UIViewController {
    static func instance<T: SNSLoginViewController>(viewModel: SNSLoginViewModel) -> T {
        let vc: T = .instance(storyboardName: .SNSLogin)
        vc.viewModel = viewModel
        return vc
    }
    
    private var viewModel: SNSLoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    deinit {
        debugPrint("------------------------------------------")
        debugPrint("SNSLoginViewController deinit")
        debugPrint("------------------------------------------")
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
        viewModel.showProfileSetup(self.navigationController)
    }
}
