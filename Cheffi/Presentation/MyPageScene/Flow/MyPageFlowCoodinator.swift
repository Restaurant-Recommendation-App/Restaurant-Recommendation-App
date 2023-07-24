//
//  MyPageFlowCoodinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit

protocol MyPageFlowCoodinatorDependencies: BaseFlowCoordinatorDependencies {
    func makeViewController() -> UIViewController
}

final class MyPageFlowCoodinator: BaseFlowCoordinator {
    private var myPageDependencies: MyPageFlowCoodinatorDependencies {
        return self.dependencies as! MyPageFlowCoodinatorDependencies
    }
    func start() {
        let vc = myPageDependencies.makeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
