//
//  SceneDelegate.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let appDIContainer = AppDIContainer()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.backgroundColor = .clear
        navigationController.navigationBar.isTranslucent = false
        
        window?.rootViewController = navigationController
        let appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        appFlowCoordinator.start()
        
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }
}

