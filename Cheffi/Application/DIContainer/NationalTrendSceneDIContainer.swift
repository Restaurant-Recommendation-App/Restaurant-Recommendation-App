//
//  NationalTrendSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import Combine

final class NationalTrendSceneDIContainer: NationalTrendFlowCoodinatorDependencies {
    func makeNationalTrendFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> NationalTrendFlowCoodinator {
        return NationalTrendFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    // MARK: - National Trend
    func makeNationalTrendViewController(reducer: NationalTrendReducer) -> NationalTrendViewController {
        NationalTrendViewController.instance(reducer: reducer)
    }
    
    func makeNationalTrendReducer(steps: PassthroughSubject<RouteStep, Never>) -> NationalTrendReducer {
        NationalTrendReducer(steps: steps)
    }
}
