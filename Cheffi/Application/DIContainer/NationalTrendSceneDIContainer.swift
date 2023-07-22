//
//  NationalTrendSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

final class NationalTrendSceneDIContainer: NationalTrendFlowCoodinatorDependencies {
    func makeNationalTrendFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> NationalTrendFlowCoodinator {
        return NationalTrendFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    func makeViewController() -> UIViewController {
        return NationalTrendViewController.instance()
    }
}
