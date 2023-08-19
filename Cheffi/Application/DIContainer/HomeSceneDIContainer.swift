//
//  HomeSceneDIContainer.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit


/// 홈화면 의존성 주입 컨테이너
final class HomeSceneDIContainer: HomeFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeHomeFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> HomeFlowCoordinator {
        return HomeFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    func makeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController.instance(viewModel: makeHomeViewModel(actions: actions))
    }
    
    func makePopupViewController(text: String, keyword: String, popupState: PopupState, findHandler: (() -> Void)?, cancelHandler: (() -> Void)?) -> PopupViewController {
        return PopupViewController.instance(text: text, keyword: keyword, popupState: popupState, findHandler: findHandler, cancelHandler: cancelHandler)
    }
    
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return HomeViewModel(actions: actions, similarChefViewModel: makeSimilarChefViewModel())
    }
    
    func makeSimilarChefViewModel() -> SimilarChefViewModel {
        let repository = makeSimilarChefRepository()
        return SimilarChefViewModel(similarChefUseCase: makeSimilarChefUseCase(repository: repository),
                                    repository: repository)
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
    func makeCheffiDetail() -> CheffiDetailViewController {
        let vc = CheffiDetailViewController.instance()
        return vc
    }
    
    func makeSimilarChefList() -> SimilarChefListViewController {
        let viewModel = makeSimilarChefListViewModel()
        return SimilarChefListViewController.instance(viewModel: viewModel)
    }
    
    func makeSimilarChefListViewModel() -> SimilarChefListViewModel {
        return SimilarChefListViewModel()
    }
}

// MARK: - Use Cases
extension HomeSceneDIContainer {
    func makeSimilarChefUseCase(repository: SimilarChefRepository) -> SimilarChefUseCase {
        return DefaultSimilarChefUseCase(repository: repository)
    }
}

// MARK: - Repositories
extension HomeSceneDIContainer {
    func makeSimilarChefRepository() -> SimilarChefRepository {
        return DefaultSimilarChefRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}
