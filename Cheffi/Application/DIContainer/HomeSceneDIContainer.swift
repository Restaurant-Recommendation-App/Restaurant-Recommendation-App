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
    
    func makeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController.instance(viewModel: makeHomeViewModel(actions: actions))
    }
    
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return HomeViewModel(
            actions: actions,
            popularRestaurantViewModel: makePopularRestaurantViewModel(numberOfContentsToShow: 2),
            similarChefViewModel: makeSimilarChefViewModel(),
            recommendationViewModel: makeRecommedationViewModel()
        )
    }
    
    func makePopularRestaurantViewModel(numberOfContentsToShow: Int) -> PopularRestaurantViewModel {
        PopularRestaurantViewModel(numberOfContentsToShow: numberOfContentsToShow)
    }
    
    func makeSimilarChefViewModel() -> SimilarChefViewModel {
        let repository = makeSimilarChefRepository()
        return SimilarChefViewModel(fetchSimilarChefUseCase: makeFetchSimilarChefUseCase(repository: repository),
                                    repository: repository)
    }
    
    func makeRecommedationViewModel() -> CheffiRecommendationViewModel {
        return CheffiRecommendationViewModel()
    }
    
    func makeFetchSimilarChefUseCase(repository: SimilarChefRepository) -> FetchSimilarChefUseCase {
        return DefaultFetchSimilarChefUseCase(repository: repository)
    }
    
    func makeSimilarChefRepository() -> SimilarChefRepository {
        return DefaultSimilarChefRepository()
    }
    
    func makePopupViewController(text: String, keyword: String) -> PopupViewController {
        return PopupViewController.instance(text: text, keyword: keyword)
    }
    
    // MARK: - Search
    func makeSearchViewController() -> SearchViewController {
        let viewModel = makeSearchViewModel()
        return SearchViewController.instance(viewModel: viewModel)
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel()
    }
    
    // MARK: - Detail
    func makeSimilarChefList() -> SimilarChefListViewController {
        let viewModel = makeSimilarChefListViewModel()
        return SimilarChefListViewController.instance(viewModel: viewModel)
    }
    
    func makeSimilarChefListViewModel() -> SimilarChefListViewModel {
        return SimilarChefListViewModel()
    }
}
