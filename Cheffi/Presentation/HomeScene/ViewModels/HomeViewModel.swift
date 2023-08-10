//
//  HomeViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

struct HomeViewModelActions {
    let showPopup: (_ text: String, _ keyword: String) -> Void
    let showSimilarChefList: () -> Void
    let showSearch: () -> Void
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
    
    func showPopup(text: String, keywrod: String) {
        actions?.showPopup(text, keywrod)
    }
    
    func showSimilarChefList() {
        actions?.showSimilarChefList()
    }
    
    func showSearch() {
        actions?.showSearch()
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
