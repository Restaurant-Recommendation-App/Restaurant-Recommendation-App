//
//  CheffiDetailViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/29.
//

import UIKit
import PanModal

class CheffiDetailViewController: UIViewController, PanModalPresentable {
    static func instance<T: CheffiDetailViewController>() -> T {
        let vc: T = .instance(storyboardName: .cheffiDetail)
        return vc
    }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageBackgroundView: UIView!
    @IBOutlet private weak var imageScrollView: UIScrollView!
    @IBOutlet private weak var imageContentView: UIView!
    @IBOutlet private weak var pageLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var cheffiMenuView: CheffiMenuView!
    @IBOutlet private weak var cheffiLocationView: CheffiLocationView!
    @IBOutlet private weak var cheffiReviewView: CheffiReviewView!
    @IBOutlet private var topLayoutConstraint: NSLayoutConstraint!
    
    // test code
    var images: [UIImage] = []
    
    enum Constants {
        static let duration: CGFloat = 0.3
        static let topContentInset: CGFloat = 185
    }
    
    // MARK: - PanModel
    var panScrollable: UIScrollView? {
        return scrollView
    }
    var topOffset: CGFloat {
        return 0.0
    }
    var cornerRadius: CGFloat {
        return 20.0
    }
    var shortFormHeight: PanModalHeight {
        return .contentHeight(view.bounds.height - Constants.topContentInset)
    }
    var longFormHeight: PanModalHeight {
        return .maxHeight
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
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        switch state {
        case .longForm:
            UIView.animate(withDuration: Constants.duration) {
                self.topLayoutConstraint.constant = 0.0
                self.indicatorView.alpha = 0.0
                self.closeButton.alpha = 0.0
                self.contentView.layoutIfNeeded()
            }
        case .shortForm:
            UIView.animate(withDuration: Constants.duration) {
                self.topLayoutConstraint.constant = 40.0
                self.indicatorView.alpha = 1.0
                self.closeButton.alpha = 1.0
                self.contentView.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        images = (0..<5).compactMap({ _ in UIImage(systemName: "star.fill") })
        setupScrollImages(images: images)
        updatePageLabel(currentPage: 0, totalPages: images.count)
    }
    
    // MARK: - Private
    private func setupViews() {
        imageScrollView.delegate = self
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
    
    func setupScrollImages(images: [UIImage]) {
        var previousImageView: UIImageView?
        
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = images[i]
            
            imageContentView.addSubview(imageView)
            
            imageView.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(imageContentView)
                make.width.equalTo(imageScrollView.snp.width)
                
                if let previousImageView = previousImageView {
                    make.leading.equalTo(previousImageView.snp.trailing)
                } else {
                    make.leading.equalTo(imageContentView.snp.leading)
                }
                
                if i == images.count - 1 {
                    make.trailing.equalTo(imageContentView.snp.trailing)
                }
            }
            
            previousImageView = imageView
        }
    }
    
    private func updatePageLabel(currentPage: Int, totalPages: Int) {
        pageLabel.text = "\(currentPage + 1)/\(totalPages)"
    }
    
    private func copyToClipboard(text: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
    }
    
    // MARK: - Actions
    @IBAction private func didTapClose(_ sender: UIButton) {
        self.dismissOne()
    }
    
    @IBAction private func didTapLike(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}

extension CheffiDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.imageScrollView else { return }
        let width = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / width)
        updatePageLabel(currentPage: currentPage, totalPages: images.count)
    }
}
