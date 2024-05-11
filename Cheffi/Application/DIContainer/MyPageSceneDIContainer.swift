//
//  MyPageSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import Combine

final class MyPageSceneDIContainer: MyPageFlowCoodinatorDependencies {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeMyPageFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> MyPageFlowCoodinator {
        return MyPageFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    // MARK: - My Page
    func makeMyPageViewController(reducer: MyPageReducer) -> MyPageViewController {
        MyPageViewController.instance(reducer: reducer)
    }
    
    func makeMyPageReducer(
        steps: PassthroughSubject<RouteStep, Never>,
        userId: Int?
    ) -> MyPageReducer {
        let useCase = makeProfileUseCase(repository: makeProfileRepository())
        return MyPageReducer(useCase: useCase, steps: steps, userId: userId)
    }
}

// MARK: - Use Cases
extension MyPageSceneDIContainer {
    private func makeProfileUseCase(repository: ProfileRepository) -> ProfileUseCase {
        DefaultProfileUseCase(repository: repository)
    }
}

// MARK: - Repositories
extension MyPageSceneDIContainer {
    private func makeProfileRepository() -> DefaultProfileRepository {
        DefaultProfileRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}
