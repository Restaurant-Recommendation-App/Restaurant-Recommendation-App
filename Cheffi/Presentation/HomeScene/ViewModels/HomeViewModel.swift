//
//  HomeViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

struct HomeViewModelActions {
    let showPopup: (_ text: String, _ keyword: String, _ popupState: PopupState) -> Void
    let showSimilarChefList: () -> Void
    let showSearch: () -> Void
    let showAllCheffiContents: () -> Void
}

protocol HomeViewModelInput {
}

protocol HomeViewModelOutput {
    var similarChefViewModel: SimilarChefViewModel { get }
    var popularRestaurantViewModel: PopularRestaurantViewModel { get }
    var recommendationViewModel: CheffiRecommendationViewModel { get }
}

final class HomeViewModel: HomeViewModelInput & HomeViewModelOutput {
    private var cancellables = Set<AnyCancellable>()
    private let actions: HomeViewModelActions?
    
    // MARK: - Input
    
    // MARK: - Output
    var similarChefViewModel: SimilarChefViewModel
    var popularRestaurantViewModel: PopularRestaurantViewModel
    var recommendationViewModel: CheffiRecommendationViewModel
    
    func showPopup(text: String, keywrod: String, popupState: PopupState) {
        actions?.showPopup(text, keywrod, popupState)
    }
    
    func showSimilarChefList() {
        actions?.showSimilarChefList()
    }
    
    func showSearch() {
        actions?.showSearch()
    }
    
    func didTapShowAllContents() {
        actions?.showAllCheffiContents()
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
