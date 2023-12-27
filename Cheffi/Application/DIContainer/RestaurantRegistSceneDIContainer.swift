//
//  RestaurantRegistSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

final class RestaurantRegistSceneDIContainer: RestaurantRegistFlowCoodinatorDependencies {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeRestaurantRegistFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> RestaurantRegistFlowCoodinator {
        return RestaurantRegistFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    // MARK: - Restaurant Regist
    func makeRestaurantRegistViewController(feature: RestaurantRegistFeature) -> RestaurantRegistViewController {
        return RestaurantRegistViewController.instance(feature: feature)
    }

    func makeRestaurantRegistFeature() -> RestaurantRegistFeature {
        let repository = makeRestaurantRepository()
        return RestaurantRegistFeature(useCase: makeRestaurantUseCase(repository: repository))
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
