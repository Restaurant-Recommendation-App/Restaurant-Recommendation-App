//
//  MyPageSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

final class MyPageSceneDIContainer: MyPageFlowCoodinatorDependencies {
    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController.instantiate(withStoryboarName: "MyPage")
    }
    
    func makeMyPageFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> MyPageFlowCoodinator {
        MyPageFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
}
