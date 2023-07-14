//
//  AppFlowCoordinator.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit
import SwifterSwift


/// 앱의 화면 전환을 담당하는 코디네이터
final class AppFlowCoordinator {
    let tabBarController: UITabBarController
    private let appDIContainer: AppDIContainer
    
    init(tabBarController: UITabBarController, appDIContainer: AppDIContainer) {
        self.tabBarController = tabBarController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        tabBarController.tabBar.isTranslucent = false
        
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let homeTabBarItem = UITabBarItem(title: "홈".localized(),
                                          image: UIImage(named: "")?.withRenderingMode(.alwaysOriginal),
                                          selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysOriginal))
        let homeNavigationController = createNavigationController(with: homeTabBarItem)
        let homeCoordinator = homeSceneDIContainer.makeHomeFlowCoordinator(
            navigationController: homeNavigationController,
            parentCoordinator: self
        )
        homeCoordinator.start()
        
        let nationalTrendSceneDIContainer = appDIContainer.makeNationalTrendSceneDIContainer()
        let nationalTrendTabBarItem = UITabBarItem(title: "전국트랜드".localized(),
                                                   image: UIImage(named: "")?.withRenderingMode(.alwaysOriginal),
                                                   selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysOriginal))
        let nationalTrendNavigationController = createNavigationController(with: nationalTrendTabBarItem)
        let nationalTrendCoordinator = nationalTrendSceneDIContainer.makeNationalTrendFlowCoordinator(
            navigationController: nationalTrendNavigationController,
            parentCoordinator: self
        )
        nationalTrendCoordinator.start()
        
        let restaurantRegistSceneDIContainer = appDIContainer.makeRestaurantRegistSceneDIContainer()
        let restaurantRegistTabBarItem = UITabBarItem(title: "맛집등록".localized(),
                                                      image: UIImage(named: "")?.withRenderingMode(.alwaysOriginal),
                                                      selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysOriginal))
        let restaurantRegistNavigationController = createNavigationController(with: restaurantRegistTabBarItem)
        let restaurantRegistCoordinator = restaurantRegistSceneDIContainer.makeRestaurantRegistFlowCoordinator(
            navigationController: restaurantRegistNavigationController,
            parentCoordinator: self
        )
        restaurantRegistCoordinator.start()
        
        let myPageSceneDIContainer = appDIContainer.makeMyPageFlowCoordinator()
        let myPageTabBarItem = UITabBarItem(title: "마이페이지".localized(),
                                            image: UIImage(named: "")?.withRenderingMode(.alwaysOriginal),
                                            selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysOriginal))
        let myPageNavigationController = createNavigationController(with: myPageTabBarItem)
        let myPageCoordinator = myPageSceneDIContainer.makeMyPageFlowCoordinator(
            navigationController: myPageNavigationController,
            parentCoordinator: self
        )
        myPageCoordinator.start()
        
        tabBarController.viewControllers = [
            homeNavigationController,
            nationalTrendNavigationController,
            restaurantRegistNavigationController,
            myPageNavigationController
        ]
    }
    
    private func createNavigationController(with tabBarItem: UITabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabBarItem
        navigationController.navigationBar.backgroundColor = .clear
        navigationController.navigationBar.isTranslucent = false
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}
