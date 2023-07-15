//
//  RestaurantRegistFlowCoodinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

protocol RestaurantRegistFlowCoodinatorDependencies: BaseFlowCoordinatorDependencies {}

final class RestaurantRegistFlowCoodinator: BaseFlowCoordinator {
    override func start() {
        let vc = dependencies.makeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
