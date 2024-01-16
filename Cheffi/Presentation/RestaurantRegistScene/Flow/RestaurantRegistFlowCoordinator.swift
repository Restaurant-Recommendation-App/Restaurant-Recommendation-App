//
//  RestaurantRegistFlowCoordinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import Combine

protocol RestaurantRegistFlowCoordinatorDependencies {
    func makeRestaurantRegistViewController(reducer: RestaurantRegistReducer) -> RestaurantRegistViewController
    func makeRestaurantRegistReducer(steps: PassthroughSubject<RouteStep, Never>) -> RestaurantRegistReducer
    func makeRestaurantRegistComposeViewController(reducer: RestaurantRegistComposeReducer) -> RestaurantRegistComposeViewController
    func makeRestaurantRegistComposeReducer(steps: PassthroughSubject<RouteStep, Never>) -> RestaurantRegistComposeReducer
    func makeRestaurantInfoComposeViewController(
        reducer: RestaurantInfoComposeReducer,
        restaurant: RestaurantInfoDTO
    ) -> RestaurantInfoComposeViewController
    func makeRestaurantInfoComposeReducer(steps: PassthroughSubject<RouteStep, Never>) -> RestaurantInfoComposeReducer
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
                case .restaurantRegistSearch: 
                    return pushRestaurantRegistSearch()
                case .restaurantRegistCompose: 
                    return pushRestaurantRegistCompose()
                case .restaurantInfoCompose(let restaurant):
                    return pushRestaurantInfoCompose(info: restaurant)
                }
            }
            .store(in: &cancellables)
        
        steps.send(.restaurantRegistSearch)
    }
    
    func pushRestaurantRegistSearch() {
        let reducer = dependencies.makeRestaurantRegistReducer(steps: steps)
        let vc = dependencies.makeRestaurantRegistViewController(reducer: reducer)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushRestaurantRegistCompose() {
        let reducer = dependencies.makeRestaurantRegistComposeReducer(steps: steps)
        let vc = dependencies.makeRestaurantRegistComposeViewController(reducer: reducer)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushRestaurantInfoCompose(info: RestaurantInfoDTO) {
        let reducer = dependencies.makeRestaurantInfoComposeReducer(steps: steps)
        let vc = dependencies.makeRestaurantInfoComposeViewController(reducer: reducer, restaurant: info)
        navigationController?.pushViewController(vc, animated: true)
    }
}
