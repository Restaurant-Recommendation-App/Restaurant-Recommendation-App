//
//  AppDIContainer.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit

final class AppDIContainer {
    func makeLoginSceneDIContainer() -> LoginSceneDIContainer {
        return LoginSceneDIContainer()
    }
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        return HomeSceneDIContainer()
    }
    
    func makeNationalTrendSceneDIContainer() -> NationalTrendSceneDIContainer {
        return NationalTrendSceneDIContainer()
    }
    
    func makeRestaurantRegistSceneDIContainer() -> RestaurantRegistSceneDIContainer {
        return RestaurantRegistSceneDIContainer()
    }
    
    func makeMyPageFlowCoordinator() -> MyPageSceneDIContainer {
        return MyPageSceneDIContainer()
    }
}
