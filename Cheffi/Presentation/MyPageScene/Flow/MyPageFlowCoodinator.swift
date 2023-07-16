//
//  MyPageFlowCoodinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit

protocol MyPageFlowCoodinatorDependencies: BaseFlowCoordinatorDependencies {}

final class MyPageFlowCoodinator: BaseFlowCoordinator {
    func start() {
        let vc = dependencies.makeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
