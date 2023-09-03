//
//  PopupViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import UIKit

enum PopupState {
    case member
    case nonMember
}

class PopupViewController: UIViewController {
    static func instance<T: PopupViewController>(text: String, keyword: String, popupState: PopupState, findHandler: (() -> Void)?, cancelHandler: (() -> Void)?) -> T {
        let vc: T = .instance(storyboardName: .popup)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.text = text
        vc.keyword = keyword
        vc.popupState = popupState
        vc.didTapFindHandler = findHandler
        vc.didTapCancelHandler = cancelHandler
        return vc
    }
    
    @IBOutlet private weak var popupView: PopupView!
    private var text: String = ""
    private var keyword: String = ""
    private var popupState: PopupState = .nonMember
    private var didTapFindHandler: (() -> Void)?
    private var didTapCancelHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        popupView.highlightKeyword(self.keyword, in: self.text)
        popupView.didTapFindHandler = { [weak self] in
            self?.dismissOne(amimated: true)
            self?.didTapFindHandler?()
        }
        popupView.didTapCancelHandler = { [weak self] in
            self?.dismissOne(amimated: true)
            self?.didTapCancelHandler?()
        }
    }
}
