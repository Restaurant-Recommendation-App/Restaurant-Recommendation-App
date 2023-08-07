//
//  LoginSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit
import Combine

protocol LoginFlowCoordinatorDependencies: BaseFlowCoordinatorDependencies {
    func makeSNSLoginViewController(actions: SNSLoginViewModelActions) -> UINavigationController
    func makeProfileSetupViewController() -> ProfileSetupViewController
}

final class LoginFlowCoordinator: BaseFlowCoordinator {
    func start() {
    }
}
