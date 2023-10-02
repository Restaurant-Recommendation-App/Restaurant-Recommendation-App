//
//  CheffiDetailViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/29.
//

import UIKit
import PanModal

class CheffiDetailViewController: UIViewController {
    static func instance<T: CheffiDetailViewController>() -> T {
        let vc: T = .instance(storyboardName: .cheffiDetail)
        return vc
    }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageBackgroundView: UIView!
    @IBOutlet private weak var cheffiContensView: CheffiContensView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var cheffiMenuView: CheffiMenuView!
    @IBOutlet private weak var cheffiLocationView: CheffiLocationView!
    @IBOutlet private weak var cheffiReviewView: CheffiReviewView!
    @IBOutlet private weak var cheffiWriterView: CheffiWriterView!
    
    private enum Constants {
        static let duration: CGFloat = 0.3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        setupViews()
        
        let items = (0..<5).map({ index in ImageItem(id: "\(index)", image: UIImage(systemName: "star.fill")!) })
        cheffiContensView.setImages(items)
    }
    
    // MARK: - Private
    private func setupViews() {
        // TODO: - test code
        let menu1 = Menu(name: "전풍 수제 돈까스", price: 12000)
        let menu2 = Menu(name: "수제 치즈 돈까스", price: 14000)
        let menu3 = Menu(name: "1인 사이드 세트", price: 3000)
        let menu4 = Menu(name: "2인 사이드 세트", price: 5000)
        let menu5 = Menu(name: "3인 사이드 세트", price: 160000)
        cheffiMenuView.setupMenu([menu1, menu2, menu3, menu4, menu5])
        
        cheffiLocationView.setLocation(Location(address: "서울 성동구 무학봉28길 7 1층"))
        cheffiLocationView.didTapCopyHandler = { [weak self] text in
            self?.showAlert(title: "복사완료", message: text)
            self?.copyToClipboard(text: text)
        }
    }
    
    private func copyToClipboard(text: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
    }
    
    // MARK: - Actions
    @IBAction private func didTapClose(_ sender: UIButton) {
        self.dismissOrPop(amimated: true)
    }
    
    @IBAction private func didTapLike(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction private func didTapMore(_ sender: UIButton) {
        // TODO: - Test code
        let vc = MoreViewController.instance()
        self.presentPanModal(vc)
    }
}

extension CheffiDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
