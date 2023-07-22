//
//  BaseFlowCoordinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit

protocol BaseFlowCoordinatorDependencies {}

class BaseFlowCoordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    var dependencies: BaseFlowCoordinatorDependencies
    
    required init(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator, dependencies: BaseFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
}
