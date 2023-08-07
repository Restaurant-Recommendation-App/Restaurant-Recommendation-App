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
    
    func makeSNSLoginViewController(actions: SNSLoginViewModelActions) -> UINavigationController {
        let viewModel = makeSNSLoginViewModel(actions: actions)
        let vc = SNSLoginViewController.instance(viewModel: viewModel)
        let navi = UINavigationController(rootViewController: vc)
        navi.navigationBar.backgroundColor = .clear
        navi.navigationBar.isTranslucent = false
        navi.setNavigationBarHidden(true, animated: false)
        navi.modalPresentationStyle = .fullScreen
        return navi
    }
    
    func makeProfileSetupViewController() -> ProfileSetupViewController {
        let viewModel = ProfileSetupViewModel()
        return ProfileSetupViewController.instance(viewModel: viewModel)
    }
    
    func makeSNSLoginViewModel(actions: SNSLoginViewModelActions) -> SNSLoginViewModel {
        return SNSLoginViewModel(actions: actions)
    }
    
    func makeProfileSetupViewModel() -> ProfileSetupViewModel {
        return ProfileSetupViewModel()
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
