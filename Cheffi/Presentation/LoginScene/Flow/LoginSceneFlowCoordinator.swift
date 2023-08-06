//
//  LoginSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit
import Combine

protocol LoginFlowCoordinatorDependencies: BaseFlowCoordinatorDependencies {
    func makeLoginViewController() -> LoginViewController
}

final class LoginFlowCoordinator: BaseFlowCoordinator {
    func start() {
    }
}
