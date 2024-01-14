//
//  RestaurantRegistFlowCoodinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

protocol RestaurantRegistFlowCoodinatorDependencies {
    func makeRestaurantRegistViewController(feature: RestaurantRegistReducer) -> RestaurantRegistViewController
    func makeRestaurantRegistFeature() -> RestaurantRegistReducer
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
        let feature = dependencies.makeRestaurantRegistFeature()
        let vc = dependencies.makeRestaurantRegistViewController(feature: feature)
        navigationController?.pushViewController(vc, animated: true)
    }
}
