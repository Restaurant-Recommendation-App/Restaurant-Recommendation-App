//
//  HomeSceneDIContainer.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit


/// 홈화면 의존성 주입 컨테이너
final class HomeSceneDIContainer: HomeFlowCoodinatorDependencies {
    
    func makeHomeViewController() -> ViewController {
        ViewController.instantiate(withStoryboarName: "Main")
    }
    
    func makeHomeFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> HomeFlowCoordinator {
        HomeFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
}
