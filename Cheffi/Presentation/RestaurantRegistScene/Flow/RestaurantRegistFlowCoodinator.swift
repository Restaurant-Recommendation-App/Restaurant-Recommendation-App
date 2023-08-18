//
//  RestaurantRegistFlowCoodinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

protocol RestaurantRegistFlowCoodinatorDependencies {
    func makeViewController() -> UIViewController
}

final class RestaurantRegistFlowCoodinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    var dependencies: RestaurantRegistFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController?, parentCoordinator: AppFlowCoordinator?, dependencies: RestaurantRegistFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
