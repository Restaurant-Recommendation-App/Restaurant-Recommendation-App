//
//  HomeSceneDIContainer.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit


/// 홈화면 의존성 주입 컨테이너
final class HomeSceneDIContainer: HomeFlowCoodinatorDependencies {
    func makeHomeFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> HomeFlowCoordinator {
        return HomeFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    func makeViewController(viewModel: HomeViewModel) -> UIViewController {
        return HomeViewController.instance(viewModel: viewModel)
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(similarChefViewModel: makeSimilarChefViewModel())
    }
    
    func makeSimilarChefViewModel() -> SimilarChefViewModel {
        let repository = makeSimilarChefRepository()
        return SimilarChefViewModel(fetchSimilarChefUseCase: makeFetchSimilarChefUseCase(repository: repository),
                                    repository: repository)
    }
    
    func makeFetchSimilarChefUseCase(repository: SimilarChefRepository) -> FetchSimilarChefUseCase {
        return DefaultFetchSimilarChefUseCase(repository: repository)
    }
    
    func makeSimilarChefRepository() -> SimilarChefRepository {
        return DefaultSimilarChefRepository()
    }
}
