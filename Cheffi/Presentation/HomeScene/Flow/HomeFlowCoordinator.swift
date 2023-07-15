//
//  HomeSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit

protocol HomeFlowCoodinatorDependencies: BaseFlowCoordinatorDependencies {}

final class HomeFlowCoordinator: BaseFlowCoordinator {
    override func start() {
        let vc = dependencies.makeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

