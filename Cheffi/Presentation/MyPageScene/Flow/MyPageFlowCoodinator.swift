//
//  MyPageFlowCoodinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit

protocol MyPageFlowCoodinatorDependencies {
    func makeViewController() -> UIViewController
}

final class MyPageFlowCoodinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    var dependencies: MyPageFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController?, parentCoordinator: AppFlowCoordinator?, dependencies: MyPageFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
