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
        HomeFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    func makeViewController() -> UIViewController {
        HomeViewController.instantiate(withStoryboarName: "Home")
    }
    
    func makeViewController(viewModel: HomeViewModel) -> UIViewController {
        let vc = HomeViewController.instantiate(withStoryboarName: "Home")
        vc.viewModel = viewModel
        return vc
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
        DefaultFetchSimilarChefUseCase(repository: repository)
    }
    
    func makeSimilarChefRepository() -> SimilarChefRepository {
        DefaultSimilarChefRepository()
    }
}
