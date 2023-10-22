//
//  CheffiReviewDetailViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/29.
//

import UIKit
import PanModal
import Combine

class CheffiReviewDetailViewController: UIViewController {
    static func instance<T: CheffiReviewDetailViewController>(viewModel: CheffiReviewDetailViewModelType) -> T {
        let vc: T = .instance(storyboardName: .cheffiReviewDetail)
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var restaurantNameLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageBackgroundView: UIView!
    @IBOutlet private weak var cheffiContensView: CheffiContensView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var cheffiMenuView: CheffiMenuView!
    @IBOutlet private weak var cheffiLocationView: CheffiLocationView!
    @IBOutlet private weak var cheffiReviewView: CheffiReviewView!
    @IBOutlet private weak var cheffiWriterView: CheffiWriterView!
    private var viewModel: CheffiReviewDetailViewModelType!
    private var cancellables = Set<AnyCancellable>()
    
    private enum Constants {
        static let duration: CGFloat = 0.3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        setupViews()
        bindViewModel()
        viewModel.input.requestGetReview()
    }
    
    // MARK: - Private
    private func setupViews() {
        // restaurant name
        restaurantNameLabel.textColor = .cheffiGray9
        restaurantNameLabel.font = Fonts.suit.weight700.size(24.0)
        
        // text
        textLabel.textColor = .cheffiGray8
        textLabel.font = Fonts.suit.weight400.size(16.0)
        
        cheffiLocationView.didTapCopyButton = { [weak self] text in
            guard let self else { return }
            let toastView = ToastView()
            toastView.show(in: self.view, message: "주소가 클립보드에 복사되었어요.".localized())
            self.copyToClipboard(text: text)
        }
        
        cheffiReviewView.didTapReviewState = { [weak self] reviewState in
            self?.viewModel.input.selectReviewState(reviewState)
        }
        
        cheffiWriterView.didTapFollowWriterInfo = { [weak self] writerInfo, isSelected in
            guard let writerInfo = writerInfo else { return }
            if isSelected {
                self?.viewModel.input.requestPostavaterFollow(id: writerInfo.id)
            } else {
                self?.viewModel.input.requestDeletAvatarFollow(id: writerInfo.id)
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.output.selectedReviewState
            .sink { [weak self] state in
                self?.cheffiReviewView.updateReviewButtons(for: state)
            }
            .store(in: &cancellables)
        
        viewModel.output.reviewInfo
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("---------------------------------------")
                    print(error)
                    print("---------------------------------------")
                }
            } receiveValue: { [weak self] results in
                guard let reviewInfo = results else {
                    // 에러 메시지
                    print("---------------------------------------")
                    print("리뷰 정보 없음")
                    print("---------------------------------------")
                    return
                }
                self?.updateContents(reviewInfo: reviewInfo)
            }
            .store(in: &cancellables)

    }
    
    private func updateContents(reviewInfo: ReviewInfoDTO) {
        // 타이틀
        restaurantNameLabel.text = reviewInfo.restaurant?.name
        // 텍스트
        textLabel.text = reviewInfo.text
        // 이미지
        cheffiContensView.setReviewInfo(reviewInfo)
        // 메뉴
        cheffiMenuView.setupMenu(reviewInfo.menus ?? [])
        // 주소
        cheffiLocationView.setLocation(reviewInfo.restaurant?.address)
        // 작성자
        cheffiWriterView.updateWriter(reviewInfo.writer)
        // 식당 별점
        cheffiReviewView.updateRatings(reviewInfo.ratings)
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

extension CheffiReviewDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
