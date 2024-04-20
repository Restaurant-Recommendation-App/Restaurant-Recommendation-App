//
//  MyPageSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import Combine

final class MyPageSceneDIContainer: MyPageFlowCoodinatorDependencies {
    func makeMyPageFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> MyPageFlowCoodinator {
        return MyPageFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    // MARK: - My Page
    func makeMyPageViewController(reducer: MyPageReducer) -> MyPageViewController {
        MyPageViewController.instance(reducer: reducer)
    }
    
    func makeMyPageReducer(steps: PassthroughSubject<RouteStep, Never>) -> MyPageReducer {
        MyPageReducer(steps: steps)
    }
}
