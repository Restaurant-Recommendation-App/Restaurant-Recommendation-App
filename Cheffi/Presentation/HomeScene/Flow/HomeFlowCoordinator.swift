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
    func makeSimilarChefList() -> UIViewController
}

final class HomeFlowCoordinator: BaseFlowCoordinator {
    private var homeDependencies: HomeFlowCoodinatorDependencies {
        return self.dependencies as! HomeFlowCoodinatorDependencies
    }
    
    func start() {
        let actions = HomeViewModelActions(showPopup: showPopup,
                                           showSimilarChefList: showSimilarChefList)
        let vc = homeDependencies.makeViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPopup(text: String, keyword: String) {
        let vc = homeDependencies.makePopupViewController(text: text, keyword: keyword)
        navigationController?.present(vc, animated: true)
    }
    
    private func showSimilarChefList() {
        let vc = homeDependencies.makeSimilarChefList()
        navigationController?.present(vc, animated: true)
    }
}

