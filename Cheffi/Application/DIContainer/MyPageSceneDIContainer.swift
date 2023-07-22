//
//  MyPageSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

final class MyPageSceneDIContainer: MyPageFlowCoodinatorDependencies {
    func makeMyPageFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> MyPageFlowCoodinator {
        return MyPageFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    func makeViewController() -> UIViewController {
        return MyPageViewController.instance()
    }
}
