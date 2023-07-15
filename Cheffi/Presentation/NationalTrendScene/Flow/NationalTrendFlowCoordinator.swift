//
//  NationalTrendFlowCoordinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

protocol NationalTrendFlowCoodinatorDependencies: BaseFlowCoordinatorDependencies {}
    
final class NationalTrendFlowCoodinator: BaseFlowCoordinator {
    override func start() {
        let vc = dependencies.makeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
