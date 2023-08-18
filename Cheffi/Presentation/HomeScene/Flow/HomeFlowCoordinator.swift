//
//  HomeSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit
import Combine

protocol HomeFlowCoordinatorDependencies {
    func makePopupViewController(text: String, keyword: String, findHandler: (() -> Void)?, cancelHandler: (() -> Void)?) -> PopupViewController
    func makeViewController(actions: HomeViewModelActions) -> HomeViewController
    func makeSimilarChefList() -> SimilarChefListViewController
    func makeSearchViewController() -> SearchViewController
    func makeCheffiDetail() -> CheffiDetailViewController
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
        let actions = HomeViewModelActions(showPopup: showPopup,
                                           showSimilarChefList: showSimilarChefList,
                                           showSearch: showSearch)
        let vc = dependencies.makeViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPopup(text: String, keyword: String) {
        let vc = dependencies.makePopupViewController(text: text, keyword: keyword, findHandler: { [weak self] in
            self?.showLogin()
        }, cancelHandler: {})
        navigationController?.present(vc, animated: true)
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
}

