//
//  AppFlowCoordinator.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit

/// 앱의 화면 전환을 담당하는 코디네이터
final class AppFlowCoordinator: NSObject {
    let tabBarController: UITabBarController
    private let appDIContainer: AppDIContainer
    var restaurantRegistFlowCoordinator: RestaurantRegistFlowCoordinator!
    var loginNavigation: UINavigationController?
    var loginFlowCoordinator: LoginFlowCoordinator?
    
    init(tabBarController: UITabBarController, appDIContainer: AppDIContainer) {
        self.tabBarController = tabBarController
        self.appDIContainer = appDIContainer
    }
    
    deinit {
#if DEBUG
        print("AppFlowCoordinator deinit")
#endif
    }
    
    func start() {
        tabBarController.delegate = self
        tabBarController.tabBar.isTranslucent = false
        addLineView()
        
        let normalAttributeName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "B1B1B1")!, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
        let selectedAttributeName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.cheffiRed, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
        
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let homeTabBarItem = UITabBarItem(title: TabBarKind.home.rawValue.localized(),
                                          image: UIImage(named: "icHomeSelected")?.withRenderingMode(.alwaysOriginal),
                                          selectedImage: UIImage(named: "icHomeSelected")?.withRenderingMode(.alwaysOriginal))
        homeTabBarItem.setTitleTextAttributes(normalAttributeName, for: .normal)
        homeTabBarItem.setTitleTextAttributes(selectedAttributeName, for: .selected)
        let homeNavigationController = createNavigationController(with: homeTabBarItem)
        let homeCoordinator = homeSceneDIContainer.makeHomeFlowCoordinator(
            navigationController: homeNavigationController,
            parentCoordinator: self
        )
        homeCoordinator.start()
        
        let nationalTrendSceneDIContainer = appDIContainer.makeNationalTrendSceneDIContainer()
        let nationalTrendTabBarItem = UITabBarItem(title: TabBarKind.nationalTrend.rawValue.localized(),
                                                   image: UIImage(named: "icNationalTrendDefault")?.withRenderingMode(.alwaysOriginal),
                                                   selectedImage: UIImage(named: "icNationalTrendDefault")?.withRenderingMode(.alwaysOriginal))
        nationalTrendTabBarItem.setTitleTextAttributes(normalAttributeName, for: .normal)
        nationalTrendTabBarItem.setTitleTextAttributes(selectedAttributeName, for: .selected)
        let nationalTrendNavigationController = createNavigationController(with: nationalTrendTabBarItem)
        let nationalTrendCoordinator = nationalTrendSceneDIContainer.makeNationalTrendFlowCoordinator(
            navigationController: nationalTrendNavigationController,
            parentCoordinator: self
        )
        nationalTrendCoordinator.start()
        
        let restaurantRegistSceneDIContainer = appDIContainer.makeRestaurantRegistSceneDIContainer()
        let restaurantRegistTabBarItem = UITabBarItem(title: TabBarKind.restaurantRegist.rawValue.localized(),
                                                      image: UIImage(named: "icRestaurantRegistDefault")?.withRenderingMode(.alwaysOriginal),
                                                      selectedImage: UIImage(named: "icRestaurantRegistDefault")?.withRenderingMode(.alwaysOriginal))
        restaurantRegistTabBarItem.setTitleTextAttributes(normalAttributeName, for: .normal)
        restaurantRegistTabBarItem.setTitleTextAttributes(selectedAttributeName, for: .selected)
        let restaurantRegistNavigationController = createNavigationController(with: restaurantRegistTabBarItem)
        let restaurantRegistCoordinator = restaurantRegistSceneDIContainer.makeRestaurantRegistFlowCoordinator(
            navigationController: restaurantRegistNavigationController,
            parentCoordinator: self
        )
        self.restaurantRegistFlowCoordinator = restaurantRegistCoordinator
        restaurantRegistCoordinator.start()
        
        let myPageSceneDIContainer = appDIContainer.makeMyPageFlowCoordinator()
        let myPageTabBarItem = UITabBarItem(title: TabBarKind.myPage.rawValue.localized(),
                                            image: UIImage(named: "icMyPageDefault")?.withRenderingMode(.alwaysOriginal),
                                            selectedImage: UIImage(named: "icMyPageDefault")?.withRenderingMode(.alwaysOriginal))
        myPageTabBarItem.setTitleTextAttributes(normalAttributeName, for: .normal)
        myPageTabBarItem.setTitleTextAttributes(selectedAttributeName, for: .selected)
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
    
    func showLogin() {
        let loginSceneDIContainer = appDIContainer.makeLoginSceneDIContainer()
        loginNavigation = nil
        loginNavigation = createLoginNavigation()
        let loginCoordinator = loginSceneDIContainer.makeLoginFlowCoordinator(navigationController: loginNavigation!,
                                                                              parentCoordinator: self)
        loginFlowCoordinator = nil
        loginFlowCoordinator = loginCoordinator
        loginCoordinator.start()
        guard let vc = loginCoordinator.navigationController else { return }
        tabBarController.present(vc, animated: true)
    }
    
    func setVCs(kind: TabBarKind, root: UIViewController) {
        var vcs = tabBarController.viewControllers ?? []
        guard !vcs.contains(where: { $0 === root }) else { return }
        vcs.insert(root, at: kind.tabBarNo)
        tabBarController.setViewControllers(vcs, animated: false)
    }
    
    func showCamera(
        isPresentPhotoAlbum: Bool,
        dismissCompletion: ((Data?) -> Void)?
    ) {
        if loginFlowCoordinator == nil {
            guard let navigationController = restaurantRegistFlowCoordinator.navigationController
            else { return }
            let loginSceneDIContainer = appDIContainer.makeLoginSceneDIContainer()
            let loginCoordinator = loginSceneDIContainer.makeLoginFlowCoordinator(
                navigationController: navigationController,
                parentCoordinator: self
            )
            self.loginFlowCoordinator = loginCoordinator
        }
        self.loginFlowCoordinator?.showCameraViewController(isPresentPhotoAlbum: isPresentPhotoAlbum, dismissCompletion: dismissCompletion)
    }
    
    func showPhotoAlbum(dismissCompletion: (([Data?]) -> Void)?) {
        if loginFlowCoordinator == nil {
            guard let navigationController = restaurantRegistFlowCoordinator.navigationController
            else { return }
            let loginSceneDIContainer = appDIContainer.makeLoginSceneDIContainer()
            let loginCoordinator = loginSceneDIContainer.makeLoginFlowCoordinator(
                navigationController: navigationController,
                parentCoordinator: self
            )
            self.loginFlowCoordinator = loginCoordinator
        }
        self.loginFlowCoordinator?.showPhotoAlbumWithoutPhotoCrop(dismissCompletion: dismissCompletion)
    }
    
    private func createLoginNavigation() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.backgroundColor = .clear
        navigationController.navigationBar.isTranslucent = false
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }

    
    private func createNavigationController(with tabBarItem: UITabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabBarItem
        navigationController.navigationBar.backgroundColor = .clear
        navigationController.navigationBar.isTranslucent = false
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
    
    private func addLineView() {
        let lineView: UIView = UIView()
        lineView.backgroundColor = .cheffiGray1
        tabBarController.tabBar.addSubview(lineView)

        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
}

extension AppFlowCoordinator: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard 
            let tabBarItemTitle = viewController.tabBarItem.title,
            let tabBarKind = TabBarKind(rawValue: tabBarItemTitle)
        else { return true }
        switch tabBarKind {
        case .nationalTrend:
            viewController.removeFromParent()
            viewController.modalPresentationStyle = .overFullScreen
            tabBarController.present(viewController, animated: true)
            return false
        case .restaurantRegist:
            viewController.removeFromParent()
            viewController.modalPresentationStyle = .fullScreen
            tabBarController.present(viewController, animated: true)
            return false
        default:
            return true
        }
    }
}
