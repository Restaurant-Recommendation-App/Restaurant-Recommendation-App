//
//  RestaurantRegistFlowCoordinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import Combine

protocol RestaurantRegistFlowCoordinatorDependencies {
    func makeRestaurantRegistSearchViewController(reducer: RestaurantRegistSearchReducer) -> RestaurantRegistSearchViewController
    func makeRestaurantRegistSearchReducer(steps: PassthroughSubject<RouteStep, Never>) -> RestaurantRegistSearchReducer
    func makeRestaurantRegistComposeViewController(reducer: RestaurantRegistComposeReducer) -> RestaurantRegistComposeViewController
    func makeRestaurantRegistComposeReducer(steps: PassthroughSubject<RouteStep, Never>) -> RestaurantRegistComposeReducer
    func makeReviewComposeViewController(
        reducer: ReviewComposeReducer,
        restaurant: RestaurantInfoDTO
    ) -> ReviewComposeViewController
    func makeReviewComposeReducer(steps: PassthroughSubject<RouteStep, Never>) -> ReviewComposeReducer
    func makeReviewHashtagsViewController(
        reducer: ReviewHashtagsReducer,
        reviewHashtagsAction: ReviewHashtagsActionType
    ) -> ReviewHashtagsViewController
    func makeReviewHashtagsReducer(steps: PassthroughSubject<RouteStep, Never>) -> ReviewHashtagsReducer
}

final class RestaurantRegistFlowCoordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    private let steps = PassthroughSubject<RouteStep, Never>()
    private var cancellables = Set<AnyCancellable>()
    var dependencies: RestaurantRegistFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController?, parentCoordinator: AppFlowCoordinator?, dependencies: RestaurantRegistFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        steps
            .sink { [weak self] step in
                guard let self else { return }
                switch step {
                case .popToNavigationController:
                    popToNavigationController()
                case .dismissRestaurantRegist:
                    dismissRestaurantRegist()
                case .pushRestaurantRegistSearch:
                    pushRestaurantRegistSearch()
                case .pushRestaurantRegistCompose:
                    pushRestaurantRegistCompose()
                case .pushReviewCompose(let restaurant):
                    pushReviewCompose(info: restaurant)
                case .presentCamera(let isPresentPhotoAlbum, let dismissCompletion):
                    presentCamera(isPresentPhotoAlbum: isPresentPhotoAlbum, dismissCompletion: dismissCompletion)
                case .presentPhotoAlbum(let dismissCompletion):
                    presentPhotoAlbum(dismissCompletion: dismissCompletion)
                case .pushReviewHashtags(let reviewHashtagsAction):
                    pushReviewHashtags(reviewHashtagsAction)
                default: break
                }
            }
            .store(in: &cancellables)
        
        steps.send(.pushRestaurantRegistSearch)
    }
    
    private func popToNavigationController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func dismissRestaurantRegist() {
        guard let navigationController else { return }
        navigationController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            parentCoordinator?.setVCs(kind: .restaurantRegist, root: navigationController)
        }
    }
    
    private func pushRestaurantRegistSearch() {
        let reducer = dependencies.makeRestaurantRegistSearchReducer(steps: steps)
        let vc = dependencies.makeRestaurantRegistSearchViewController(reducer: reducer)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushRestaurantRegistCompose() {
        let reducer = dependencies.makeRestaurantRegistComposeReducer(steps: steps)
        let vc = dependencies.makeRestaurantRegistComposeViewController(reducer: reducer)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushReviewCompose(info: RestaurantInfoDTO) {
        let reducer = dependencies.makeReviewComposeReducer(steps: steps)
        let vc = dependencies.makeReviewComposeViewController(reducer: reducer, restaurant: info)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentCamera(
        isPresentPhotoAlbum: Bool,
        dismissCompletion: ((Data?) -> Void)?
    ) {
        parentCoordinator?.showCamera(isPresentPhotoAlbum: isPresentPhotoAlbum, dismissCompletion: dismissCompletion)
    }
    
    private func presentPhotoAlbum(dismissCompletion: (([Data?]) -> Void)?) {
        parentCoordinator?.showPhotoAlbum(dismissCompletion: dismissCompletion)
    }
    
    private func pushReviewHashtags(_ reviewHashtagsAction: ReviewHashtagsActionType) {
        let reducer = dependencies.makeReviewHashtagsReducer(steps: steps)
        let vc = dependencies.makeReviewHashtagsViewController(reducer: reducer, reviewHashtagsAction: reviewHashtagsAction)
        navigationController?.pushViewController(vc, animated: true)
    }
}
