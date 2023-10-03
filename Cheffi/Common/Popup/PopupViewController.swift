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
    case deleteNotification
}

class PopupViewController: UIViewController {
    static func instance<T: PopupViewController>(text: String,
                                                 subText: String,
                                                 keyword: String,
                                                 popupState: PopupState,
                                                 leftButtonTitle: String,
                                                 rightButtonTitle: String,
                                                 leftHandler: (() -> Void)?,
                                                 rightHandler: (() -> Void)?) -> T {
        let vc: T = .instance(storyboardName: .popup)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.text = text
        vc.subText = subText
        vc.keyword = keyword
        vc.popupState = popupState
        vc.leftButtonTitle = leftButtonTitle
        vc.rightButtonTitle = rightButtonTitle
        vc.didTapLeftHandler = leftHandler
        vc.didTapRightHandler = rightHandler
        return vc
    }
    
    @IBOutlet private weak var popupView: PopupView!
    private var text: String = ""
    private var keyword: String = ""
    private var popupState: PopupState = .nonMember
    private var subText: String = ""
    private var leftButtonTitle: String = ""
    private var rightButtonTitle: String = ""
    private var didTapLeftHandler: (() -> Void)?
    private var didTapRightHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        popupView.highlightKeyword(self.keyword, in: self.text)
        popupView.setSubTextLabelText(text: subText)
        popupView.setLeftButtonText(text: leftButtonTitle)
        popupView.setRightButtonText(text: rightButtonTitle)
        popupView.didTapLeftHandler = { [weak self] in
            self?.dismissOne(amimated: true)
            self?.didTapLeftHandler?()
        }
        popupView.didTapRightHandler = { [weak self] in
            self?.dismissOne(amimated: true)
            self?.didTapRightHandler?()
        }
    }
}
