//
//  PopupViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import UIKit

class PopupViewController: UIViewController {
    static func instance<T: PopupViewController>(text: String, keyword: String) -> T {
        let vc: T = .instance(storyboardName: .popup)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.text = text
        vc.keyword = keyword
        return vc
    }
    
    @IBOutlet private weak var popupView: PopupView!
    private var text: String = ""
    private var keyword: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        popupView.setText(text: self.text, keyword: self.keyword)
        popupView.didTapCancelHandler = { [weak self] in
            self?.dismissOne()
        }
        
        popupView.didTapFindHandler = { [weak self] in
        }
    }
}
