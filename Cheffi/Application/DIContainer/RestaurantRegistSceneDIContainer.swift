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
    func makeRestaurantRegistSearchViewController(reducer: RestaurantRegistSearchReducer) -> RestaurantRegistSearchViewController {
        return RestaurantRegistSearchViewController.instance(reducer: reducer)
    }

    func makeRestaurantRegistSearchReducer(steps: PassthroughSubject<RouteStep, Never>) -> RestaurantRegistSearchReducer {
        let repository = makeRestaurantRepository()
        return RestaurantRegistSearchReducer(useCase: makeRestaurantUseCase(repository: repository), steps: steps)
    }
    
    // MARK: - Restaurant Regist Compose
    func makeRestaurantRegistComposeViewController(reducer: RestaurantRegistComposeReducer) -> RestaurantRegistComposeViewController {
        return RestaurantRegistComposeViewController(reducer: reducer)
    }
    
    func makeRestaurantRegistComposeReducer(steps: PassthroughSubject<RouteStep, Never>) -> RestaurantRegistComposeReducer {
        let repository = makeRestaurantRepository()
        return RestaurantRegistComposeReducer(
            useCase: makeRestaurantUseCase(repository: repository), 
            steps: steps
        )
    }
    
    // MARK: - Review Compose
    func makeReviewComposeViewController(
        reducer: ReviewComposeReducer,
        restaurant: RestaurantInfoDTO
    ) -> ReviewComposeViewController {
        return ReviewComposeViewController(reducer: reducer, restaurant: restaurant)
    }
    
    func makeReviewComposeReducer(steps: PassthroughSubject<RouteStep, Never>) -> ReviewComposeReducer {
        let repository = makeRestaurantRepository()
        return ReviewComposeReducer(
            useCase: makeRestaurantUseCase(repository: repository),
            steps: steps
        )
    }
    
    // MARK: - Review Hashtags
    func makeReviewHashtagsViewController(
        reducer: ReviewHashtagsReducer,
        reviewHashtagsAction: ReviewHashtagsActionType
    ) -> ReviewHashtagsViewController {
        ReviewHashtagsViewController(reducer: reducer, reviewHashtagsAction: reviewHashtagsAction)
    }
    
    func makeReviewHashtagsReducer(steps: PassthroughSubject<RouteStep, Never>) -> ReviewHashtagsReducer {
        let repository = makeRestaurantRepository()
        return ReviewHashtagsReducer(
            useCase: makeRestaurantUseCase(repository: repository),
            steps: steps
        )
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
