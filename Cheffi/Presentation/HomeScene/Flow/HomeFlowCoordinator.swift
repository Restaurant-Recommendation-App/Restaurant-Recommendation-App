//
//  HomeSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit
import Combine

protocol HomeFlowCoodinatorDependencies: BaseFlowCoordinatorDependencies {
    func makeViewController(actions: HomeViewModelActions) -> HomeViewController
    func makeSimilarChefList() -> SimilarChefListViewController
    func makeSearchViewController() -> SearchViewController
    func makeCheffiDetail() -> CheffiDetailViewController
}

final class HomeFlowCoordinator: BaseFlowCoordinator {
    private var homeDependencies: HomeFlowCoodinatorDependencies {
        return self.dependencies as! HomeFlowCoodinatorDependencies
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
            guard let detailVC = self?.homeDependencies.makeCheffiDetail() else { return }
            self?.navigationController?.pushViewController(detailVC)
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
}

