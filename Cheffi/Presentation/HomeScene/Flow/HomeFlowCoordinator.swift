//
//  HomeSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit

protocol HomeFlowCoodinatorDependencies: BaseFlowCoordinatorDependencies {
    func makeViewController(viewModel: HomeViewModel) -> UIViewController
}

final class HomeFlowCoordinator: BaseFlowCoordinator {
    private var homeDependencies: HomeFlowCoodinatorDependencies {
        return self.dependencies as! HomeFlowCoodinatorDependencies
    }
    
    func start(viewModel: HomeViewModel) {
        let vc = homeDependencies.makeViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

