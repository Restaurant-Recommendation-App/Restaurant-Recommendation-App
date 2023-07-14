//
//  HomeSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit

protocol HomeFlowCoodinatorDependencies {
    func makeHomeViewController() -> ViewController
}

final class HomeFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private weak var parentCoordinator: AppFlowCoordinator?
    
    private let dependencies: HomeFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator, dependencies: HomeFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeHomeViewController()
        // 타이틀 등 네비게이션 관련 세팅
        navigationController?.pushViewController(vc, animated: true)
    }
}

