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
    
    func makeNotificationViewController(actions: NotificationViewModelActions) -> NotificationViewController {
        let viewModel = makeNotificationViewModel(actions: actions)
        return NotificationViewController.instance(viewModel: viewModel)
    }
    
    // MARK: - Home ViewModels
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return HomeViewModel(
            actions: actions,
            popularRestaurantViewModel: makePopularRestaurantViewModel(),
            similarChefViewModel: makeSimilarChefViewModel(),
            recommendationViewModel: makeRecommedationViewModel()
        )
    }
    
    func makePopularRestaurantViewModel() -> PopularRestaurantViewModel {
        let repository = makeCheffiRecommendationRepository()
        return PopularRestaurantViewModel(cheffiRecommendationUseCase: makeCheffiRecommendationUseCase(repository: repository))
    }
    
    func makeSimilarChefViewModel() -> SimilarChefViewModel {
        let repository = makeSimilarChefRepository()
        return SimilarChefViewModel(useCase: makeSimilarChefUseCase(repository: repository))
    }
    
    func makeRecommedationViewModel() -> CheffiRecommendationViewModel {
        let repository = makeCheffiRecommendationRepository()
        return CheffiRecommendationViewModel(cheffiRecommendationUseCase: makeCheffiRecommendationUseCase(repository: repository))
    }
    
    func makeNotificationViewModel(actions: NotificationViewModelActions) -> NotificationViewModel {
        let repository = makeNotificationRepository()
        let useCase = makeNotificationUseCase(repository: repository)
        return NotificationViewModel(actions: actions, useCase: useCase)
    }
    
    // MARK: - Search
    func makeSearchViewController() -> SearchViewController {
        let viewModel = makeSearchViewModel()
        return SearchViewController.instance(viewModel: viewModel)
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel()
    }
    
    func makeAllCheffiContentsViewModel() -> AllCheffiContentsViewModel {
        let useCase = makeCheffiRecommendationUseCase(repository: makeCheffiRecommendationRepository())
        return AllCheffiContentsViewModel(
            tag: "popularity",
            cheffiRecommendationUseCase: useCase)
    }
    
    // MARK: - Review Detail
    func makeCheffiReviewDetail(reviewId: Int) -> CheffiReviewDetailViewController {
        let viewModel = makeCheffiReviewViewModel(reviewId: reviewId)
        let vc = CheffiReviewDetailViewController.instance(viewModel: viewModel)
        return vc
    }
    
    func makeCheffiReviewViewModel(reviewId: Int) -> CheffiReviewDetailViewModelType {
        let repository = makeReviewRepository()
        return CheffiReviewDetailViewModel(reviewId: reviewId, useCase: makeReviewUseCase(repository: repository))
    }
    
    func makeSimilarChefList() -> SimilarChefListViewController {
        let viewModel = makeSimilarChefListViewModel()
        return SimilarChefListViewController.instance(viewModel: viewModel)
    }
    
    func makeSimilarChefListViewModel() -> SimilarChefListViewModel {
        return SimilarChefListViewModel()
    }
    
    func makeAllCheffiContentsViewController() -> AllCheffiContentsViewController {
        let vc = AllCheffiContentsViewController()
        vc.viewModel = makeAllCheffiContentsViewModel()
        vc.view.backgroundColor = .white
        return vc
    }
}

// MARK: - Use Cases
extension HomeSceneDIContainer {
    func makeSimilarChefUseCase(repository: SimilarChefRepository) -> SimilarChefUseCase {
        return DefaultSimilarChefUseCase(repository: repository)
    }
    
    func makeCheffiRecommendationUseCase(repository: CheffiRecommendationRepository) -> CheffiRecommendationUseCase {
        return DefaultCheffiRecommendationUseCase(repository: repository)
    }
    
    func makeNotificationUseCase(repository: NotificationRepository) -> NotificationUseCase {
        return DefaultNotificationUseCase(repository: repository)
    }
    
    func makeReviewUseCase(repository: ReviewRepository) -> ReviewUseCase {
        return DefaultReviewUseCase(repository: repository)
    }
}

// MARK: - Repositories
extension HomeSceneDIContainer {
    func makeSimilarChefRepository() -> SimilarChefRepository {
        return DefaultSimilarChefRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeCheffiRecommendationRepository() -> CheffiRecommendationRepository {
        return DefaultCheffiRecommendationRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeNotificationRepository() -> NotificationRepository {
        return DefaultNotificationRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeReviewRepository() -> ReviewRepository {
        return DefaultReviewRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}
