//
//  SimilarChefListViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import UIKit

class SimilarChefListViewController: UIViewController {
    static func instance<T: SimilarChefListViewController>(viewModel: SimilarChefListViewModel) -> T {
        let vc: T = .instance(storyboardName: .similarChefList)
        vc.viewModel = viewModel
        return vc
    }
    
    private var viewModel: SimilarChefListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupViews()
    }
    
    // MARK: - Private
    private func bindViewModel() {
        
    }
    private func setupViews() {
        
    }
    
    // MARK: - Actions
    @IBAction private func didTapBack(_ sender: UIButton) {
        self.dismissOrPop(amimated: true)
    }
}
