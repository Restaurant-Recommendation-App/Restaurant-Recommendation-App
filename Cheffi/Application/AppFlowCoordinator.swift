//
//  AppFlowCoordinator.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit


/// 앱의 화면 전환을 담당하는 코디네이터
final class AppFlowCoordinator {
    let navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let flow = homeSceneDIContainer.makeHomeFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        flow.start()
    }
}
