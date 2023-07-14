//
//  NationalTrendSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

final class NationalTrendSceneDIContainer: NationalTrendFlowCoodinatorDependencies {
    func makeNationalTrendViewController() -> NationalTrendViewController {
        NationalTrendViewController.instantiate(withStoryboarName: "NationalTrend")
    }
    
    func makeNationalTrendFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> NationalTrendFlowCoodinator {
        NationalTrendFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
}
