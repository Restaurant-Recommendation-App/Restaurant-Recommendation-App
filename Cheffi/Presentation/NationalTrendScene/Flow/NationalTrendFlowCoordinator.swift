//
//  NationalTrendFlowCoordinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

protocol NationalTrendFlowCoodinatorDependencies {
    func makeNationalTrendViewController() -> NationalTrendViewController
}

final class NationalTrendFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private weak var parentCoordinator: AppFlowCoordinator?
    
    private let dependencies: NationalTrendFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator, dependencies: NationalTrendFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeNationalTrendViewController()
        // 타이틀 등 네비게이션 관련 세팅
        navigationController?.pushViewController(vc, animated: true)
    }
}
