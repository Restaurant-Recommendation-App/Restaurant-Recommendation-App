//
//  MyPageFlowCoodinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit

protocol MyPageFlowCoodinatorDependencies {
    func makeMyPageViewController() -> MyPageViewController
}

final class MyPageFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private weak var parentCoordinator: AppFlowCoordinator?
    
    private let dependencies: MyPageFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator, dependencies: MyPageFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeMyPageViewController()
        // 타이틀 등 네비게이션 관련 세팅
        navigationController?.pushViewController(vc, animated: true)
    }
}
