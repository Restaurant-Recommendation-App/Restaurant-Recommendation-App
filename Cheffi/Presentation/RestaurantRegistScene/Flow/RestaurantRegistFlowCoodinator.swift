//
//  RestaurantRegistFlowCoodinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

protocol RestaurantRegistFlowCoodinatorDependencies {
    func makeRestaurantRegistViewController() -> RestaurantRegistViewController
}

final class RestaurantRegistFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private weak var parentCoordinator: AppFlowCoordinator?
    
    private let dependencies: RestaurantRegistFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator, dependencies: RestaurantRegistFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeRestaurantRegistViewController()
        // 타이틀 등 네비게이션 관련 세팅
        navigationController?.pushViewController(vc, animated: true)
    }
}
