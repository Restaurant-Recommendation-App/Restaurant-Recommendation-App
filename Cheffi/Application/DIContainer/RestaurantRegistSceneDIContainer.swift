//
//  RestaurantRegistSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

final class RestaurantRegistSceneDIContainer: RestaurantRegistFlowCoodinatorDependencies {
    func makeRestaurantRegistViewController() -> RestaurantRegistViewController {
        RestaurantRegistViewController.instantiate(withStoryboarName: "RestaurantRegist")
    }
    
    func makeRestaurantRegistFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> RestaurantRegistFlowCoodinator {
        RestaurantRegistFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
}
