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
        
        let tabBarController = UITabBarController()
        window?.rootViewController = tabBarController
        let appFlowCoordinator = AppFlowCoordinator(
            tabBarController: tabBarController,
            appDIContainer: appDIContainer
        )
        appFlowCoordinator.start()
        
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }
}

