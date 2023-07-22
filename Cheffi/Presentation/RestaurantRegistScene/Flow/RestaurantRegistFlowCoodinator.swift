//
//  RestaurantRegistFlowCoodinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

protocol RestaurantRegistFlowCoodinatorDependencies: BaseFlowCoordinatorDependencies {
    func makeViewController() -> UIViewController
}

final class RestaurantRegistFlowCoodinator: BaseFlowCoordinator {
    private var restaurantRegistDependencies: RestaurantRegistFlowCoodinatorDependencies {
        return self.dependencies as! RestaurantRegistFlowCoodinatorDependencies
    }
    
    func start() {
        let vc = restaurantRegistDependencies.makeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
