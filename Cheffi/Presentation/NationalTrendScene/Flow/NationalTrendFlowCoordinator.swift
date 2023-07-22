//
//  NationalTrendFlowCoordinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

protocol NationalTrendFlowCoodinatorDependencies: BaseFlowCoordinatorDependencies {
    func makeViewController() -> UIViewController
}
    
final class NationalTrendFlowCoodinator: BaseFlowCoordinator {
    private var nationalTrendDependencies: NationalTrendFlowCoodinatorDependencies {
        return self.dependencies as! NationalTrendFlowCoodinatorDependencies
    }
    
    func start() {
        let vc = nationalTrendDependencies.makeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
