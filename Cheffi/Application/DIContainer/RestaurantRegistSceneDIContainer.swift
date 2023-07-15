//
//  RestaurantRegistSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

final class RestaurantRegistSceneDIContainer: RestaurantRegistFlowCoodinatorDependencies {
    func makeRestaurantRegistFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> RestaurantRegistFlowCoodinator {
        RestaurantRegistFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    func makeViewController() -> UIViewController {
        RestaurantRegistViewController.instantiate(withStoryboarName: "RestaurantRegist")
    }
}
