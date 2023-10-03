//
//  HomeViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

struct HomeViewModelActions {
    let showPopup: (_ text: String, _ subText: String, _ keyword: String, _ popupState: PopupState,_  leftButtonTitle: String, _ rightButtonTitle: String, _ leftHandler: (() -> Void)?, _ rightHandler: (() -> Void)?) -> Void
    let showSimilarChefList: () -> Void
    let showSearch: () -> Void
    let showNotification: () -> Void
}

protocol HomeViewModelInput {
}

protocol HomeViewModelOutput {
    var similarChefViewModel: SimilarChefViewModel { get }
    var popularRestaurantViewModel: PopularRestaurantViewModel { get }
    var recommendationViewModel: CheffiRecommendationViewModel { get }
    func showPopup(text: String, subText: String, keywrod: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String)
    func showSimilarChefList()
    func showSearch()
    func showNotification()
}

typealias HomeViewModelType = HomeViewModelInput & HomeViewModelOutput

final class HomeViewModel: HomeViewModelType {
    private var cancellables = Set<AnyCancellable>()
    private let actions: HomeViewModelActions?
    
    // MARK: - Input
    
    // MARK: - Output
    var similarChefViewModel: SimilarChefViewModel
    var popularRestaurantViewModel: PopularRestaurantViewModel
    var recommendationViewModel: CheffiRecommendationViewModel
    
    func showPopup(text: String, subText: String, keywrod: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String) {
        actions?.showPopup(text, subText, keywrod, popupState, leftButtonTitle, rightButtonTitle, nil, nil)
    }
    
    func showSimilarChefList() {
        actions?.showSimilarChefList()
    }
    
    func showSearch() {
        actions?.showSearch()
    }
    
    func showNotification() {
        actions?.showNotification()
    }

    // MARK: - Init
    init(
        actions: HomeViewModelActions,
        popularRestaurantViewModel: PopularRestaurantViewModel,
        similarChefViewModel: SimilarChefViewModel,
        recommendationViewModel: CheffiRecommendationViewModel
    ) {
        self.actions = actions
        self.popularRestaurantViewModel = popularRestaurantViewModel
        self.similarChefViewModel = similarChefViewModel
        self.recommendationViewModel = recommendationViewModel
    }
}
