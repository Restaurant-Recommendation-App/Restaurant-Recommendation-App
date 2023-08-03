//
//  RestaurantRegistSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

final class RestaurantRegistSceneDIContainer: RestaurantRegistFlowCoodinatorDependencies {
    func makeRestaurantRegistFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> RestaurantRegistFlowCoodinator {
        return RestaurantRegistFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    func makeViewController() -> UIViewController {
        return RestaurantRegistViewController.instance()
    }
    
    func makePopupViewController(text: String, keyword: String, findHandler: (() -> Void)?, cancelHandler: (() -> Void)?) -> PopupViewController {
        return PopupViewController.instance(text: text, keyword: keyword, findHandler: findHandler, cancelHandler: cancelHandler)
    }
}
