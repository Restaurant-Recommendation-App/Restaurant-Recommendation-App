//
//  RestaurantRegistSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import Combine

final class RestaurantRegistSceneDIContainer: RestaurantRegistFlowCoordinatorDependencies {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeRestaurantRegistFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> RestaurantRegistFlowCoordinator {
        return RestaurantRegistFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    // MARK: - Restaurant Regist Search
    func makeRestaurantRegistViewController(reducer: RestaurantRegistReducer) -> RestaurantRegistViewController {
        return RestaurantRegistViewController.instance(reducer: reducer)
    }

    func makeRestaurantRegistReducer(steps: PassthroughSubject<RouteStep, Never>) -> RestaurantRegistReducer {
        let repository = makeRestaurantRepository()
        return RestaurantRegistReducer(useCase: makeRestaurantUseCase(repository: repository), steps: steps)
    }
    
    // MARK: - Restaurant Regist Compose
    func makeRestaurantRegistComposeViewController(reducer: RestaurantRegistComposeReducer) -> RestaurantRegistComposeViewController {
        return RestaurantRegistComposeViewController(reducer: reducer)
    }
    
    func makeRestaurantRegistComposeReducer(steps: PassthroughSubject<RouteStep, Never>) -> RestaurantRegistComposeReducer {
        return RestaurantRegistComposeReducer(steps: steps)
    }
    
    // MARK: - Restaurant Info Compose
    func makeRestaurantInfoComposeViewController(
        reducer: RestaurantInfoComposeReducer,
        restaurant: RestaurantInfoDTO
    ) -> RestaurantInfoComposeViewController {
        return RestaurantInfoComposeViewController(reducer: reducer, restaurant: restaurant)
    }
    
    func makeRestaurantInfoComposeReducer(steps: PassthroughSubject<RouteStep, Never>) -> RestaurantInfoComposeReducer {
        return RestaurantInfoComposeReducer(steps: steps)
    }

    // MARK: - Popup
    func makePopupViewController(text: String, subText: String, keyword: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String, leftHandler: (() -> Void)?, rightHandler: (() -> Void)?) -> PopupViewController {
        return PopupViewController.instance(text: text,
                                            subText: subText,
                                            keyword: keyword,
                                            popupState: popupState,
                                            leftButtonTitle: leftButtonTitle,
                                            rightButtonTitle: rightButtonTitle,
                                            leftHandler: leftHandler,
                                            rightHandler: rightHandler)
    }
}

// MARK: - Use Cases
extension RestaurantRegistSceneDIContainer {
    func makeRestaurantUseCase(repository: RestaurantRepository) -> RestaurantUseCase {
        return DefaultRestaurantUseCase(repository: repository)
    }
}

// MARK: - Repositories
extension RestaurantRegistSceneDIContainer {
    func makeRestaurantRepository() -> DefaultRestaurantRepository {
        return DefaultRestaurantRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}
