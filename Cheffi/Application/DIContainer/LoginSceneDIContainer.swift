//
//  LoginSceneDIContainer.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit


final class LoginSceneDIContainer: LoginFlowCoordinatorDependencies {
    func makeLoginFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> LoginFlowCoordinator {
        return LoginFlowCoordinator(navigationController: navigationController,
                                    parentCoordinator: parentCoordinator,
                                    dependencies: self)
    }
    
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController.instance(viewModel: makeLoginViewModel())
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel()
    }
    
    // MAKR: - PopupViewController
    func makePopupViewController(text: String, keyword: String, findHandler: (() -> Void)?, cancelHandler: (() -> Void)?) -> PopupViewController {
        return PopupViewController.instance(text: text, keyword: keyword, findHandler: findHandler, cancelHandler: cancelHandler)
    }
    
    // MARK: - Picker
    func makePickerViewController() -> UIViewController {
        return UIViewController()
    }
}
