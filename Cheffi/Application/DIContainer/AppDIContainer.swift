//
//  AppDIContainer.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit

final class AppDIContainer {
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        HomeSceneDIContainer()
    }
    
    func makeNationalTrendSceneDIContainer() -> NationalTrendSceneDIContainer {
        NationalTrendSceneDIContainer()
    }
    
    func makeRestaurantRegistSceneDIContainer() -> RestaurantRegistSceneDIContainer {
        RestaurantRegistSceneDIContainer()
    }
    
    func makeMyPageFlowCoordinator() -> MyPageSceneDIContainer {
        MyPageSceneDIContainer()
    }
}
