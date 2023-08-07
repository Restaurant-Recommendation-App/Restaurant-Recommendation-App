//
//  MoreViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import UIKit
import PanModal

final class MoreViewController: UIViewController, PanModalPresentable {
    static func instance<T: MoreViewController>() -> T {
        let vc: T = .instance(storyboardName: .more)
        return vc
    }
    
    @IBOutlet private weak var reportLabel: UILabel!
    
    var panScrollable: UIScrollView? {
        return nil
    }
    var topOffset: CGFloat {
        return 0.0
    }
    var cornerRadius: CGFloat {
        return 20.0
    }
    var longFormHeight: PanModalHeight {
        return .contentHeight(132)
    }
    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.25)
    }
    var shouldRoundTopCorners: Bool {
        return true
    }
    var showDragIndicator: Bool {
        return false
    }
    var anchorModalToLongForm: Bool {
        return false
    }
    
    func panModalDidDismiss() {
        debugPrint("------------------------------------------")
        debugPrint("panModalDidDismiss")
        debugPrint("------------------------------------------")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        reportLabel.text = "신고하기".localized()
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @IBAction private func didTapReport(_ sender: UIButton) {
        debugPrint("------------------------------------------")
        debugPrint("신고 하기")
        debugPrint("------------------------------------------")
    }
}
