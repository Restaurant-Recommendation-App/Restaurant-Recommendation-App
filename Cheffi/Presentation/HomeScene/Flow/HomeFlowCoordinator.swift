//
//  HomeSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit
import Combine

protocol HomeFlowCoordinatorDependencies: BaseFlowCoordinatorDependencies {
    func makeViewController(actions: HomeViewModelActions) -> HomeViewController
    func makeSimilarChefList() -> SimilarChefListViewController
    func makeSearchViewController() -> SearchViewController
    func makeCheffiDetail() -> CheffiDetailViewController
}

final class HomeFlowCoordinator: BaseFlowCoordinator {
    private var homeDependencies: HomeFlowCoordinatorDependencies {
        return self.dependencies as! HomeFlowCoordinatorDependencies
    }
    
    func start() {
        let actions = HomeViewModelActions(showPopup: showPopup,
                                           showSimilarChefList: showSimilarChefList,
                                           showSearch: showSearch)
        let vc = homeDependencies.makeViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPopup(text: String, keyword: String) {
        let vc = homeDependencies.makePopupViewController(text: text, keyword: keyword, findHandler: { [weak self] in
            self?.showLogin()
        }, cancelHandler: {})
        navigationController?.present(vc, animated: true)
    }
    
    private func showSimilarChefList() {
        let vc = homeDependencies.makeSimilarChefList()
        navigationController?.pushViewController(vc)
    }
    
    private func showSearch() {
        let vc = homeDependencies.makeSearchViewController()
        navigationController?.pushViewController(vc)
    }
    
    private func showLogin() {
        parentCoordinator?.showLogin()
    }
}

