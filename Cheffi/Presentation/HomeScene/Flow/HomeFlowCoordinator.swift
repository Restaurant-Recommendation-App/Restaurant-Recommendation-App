//
//  HomeSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit
import Combine

protocol HomeFlowCoordinatorDependencies {
    func makePopupViewController(text: String, subText: String, keyword: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String, leftHandler: (() -> Void)?, rightHandler: (() -> Void)?) -> PopupViewController
    func makeViewController(actions: HomeViewModelActions) -> HomeViewController
    func makeSimilarChefList() -> SimilarChefListViewController
    func makeSearchViewController() -> SearchViewController
    func makeCheffiReviewDetail(reviewId: Int) -> CheffiReviewDetailViewController
    func makeAllCheffiContentsViewController(actions: AllCheffiContentsViewModelActions) -> AllCheffiContentsViewController
    func makeNotificationViewController(actions: NotificationViewModelActions) -> NotificationViewController
    func makeAreaSelectionViewController() -> AreaSelectionViewController
}

final class HomeFlowCoordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    var dependencies: HomeFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController?, parentCoordinator: AppFlowCoordinator?, dependencies: HomeFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = HomeViewModelActions(showSNSLoginView: showSNSLoginView,
                                           showPopup: showPopup,
                                           showSimilarChefList: showSimilarChefList,
                                           showSearch: showSearch,
                                           showAllCheffiContents: showAllCheffiContents,
                                           showNotification: showNotification,
                                           showCheffiReviewDetail: showCheffiReviewDetail,
                                           showAreaSelection: showAreaSelection)
        let vc = dependencies.makeViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // TODO: 회원가입 api 연동 완료 후 제거 필요
    private func showSNSLoginView() {
        showLogin()
    }
    
    private func showPopup(text: String, subText: String, keyword: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String, leftHandler: (() -> Void)?, rightHandler: (() -> Void)?) {
        let vc = dependencies.makePopupViewController(text: text,
                                                      subText: subText,
                                                      keyword: keyword,
                                                      popupState: popupState,
                                                      leftButtonTitle: leftButtonTitle,
                                                      rightButtonTitle: rightButtonTitle,
                                                      leftHandler: { leftHandler?() },
                                                      rightHandler: { [weak self] in
            rightHandler?()
            switch popupState {
            case .member(let id):
                self?.showCheffiReviewDetail(reviewId: id)
            case .nonMember:
                self?.showLogin()
            case .deleteNotification:
                break
            }
        })
        
        if let presentVC = navigationController?.presentedViewController {
            presentVC.present(vc, animated: true)
        } else {
            navigationController?.present(vc, animated: true)
        }
    }
    
    private func showSimilarChefList() {
        let vc = dependencies.makeSimilarChefList()
        navigationController?.pushViewController(vc)
    }
    
    private func showSearch() {
        let vc = dependencies.makeSearchViewController()
        navigationController?.pushViewController(vc)
    }
    
    private func showLogin() {
        parentCoordinator?.showLogin()
    }
    
    private func showCheffiReviewDetail(reviewId: Int) {
        let vc = dependencies.makeCheffiReviewDetail(reviewId: reviewId)
        navigationController?.pushViewController(vc)
    }
    
    private func showAllCheffiContents() {
        let actions = AllCheffiContentsViewModelActions(showAreaSelection: showAreaSelection)
        let vc = dependencies.makeAllCheffiContentsViewController(actions: actions)
        navigationController?.pushViewController(vc)
    }
    
    private func showNotification() {
        let actions = NotificationViewModelActions(showPopup: showPopup)
        let vc = dependencies.makeNotificationViewController(actions: actions)
        navigationController?.present(vc, animated: true)
    }
    
    private func showAreaSelection() {
        let vc = dependencies.makeAreaSelectionViewController()
        navigationController?.pushViewController(vc)
    }
}
