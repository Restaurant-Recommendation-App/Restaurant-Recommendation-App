//
//  AppDIContainer.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            headers: ["Content-Type": "application/json"],
            queryParameters: [:]
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    func makeLoginSceneDIContainer() -> LoginSceneDIContainer {
        let dependencies = LoginSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return LoginSceneDIContainer(dependencies: dependencies)
    }
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        let dependencies = HomeSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return HomeSceneDIContainer(dependencies: dependencies)
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
