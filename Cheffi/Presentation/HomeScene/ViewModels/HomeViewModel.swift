//
//  HomeViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

struct HomeViewModelActions {
    let showSNSLoginView: () -> Void // TODO: 회원가입 api 연동 완료 후 제거 필요
    let showPopup: (_ text: String, _ subText: String, _ keyword: String, _ popupState: PopupState,_  leftButtonTitle: String, _ rightButtonTitle: String, _ leftHandler: (() -> Void)?, _ rightHandler: (() -> Void)?) -> Void
    let showSimilarChefList: () -> Void
    let showSearch: () -> Void
    let showAllCheffiContents: () -> Void
    let showNotification: () -> Void
    let showCheffiReviewDetail: (_ reviewId: Int) -> Void
    let showAreaSelection: () -> Void
}

protocol HomeViewModelInput {
}

protocol HomeViewModelOutput {
    var similarChefViewModel: SimilarChefViewModel { get }
    var popularRestaurantViewModel: PopularRestaurantViewModel { get }
    var recommendationViewModel: CheffiRecommendationViewModel { get }
    func showSNSLoginView() // TODO: 회원가입 api 연동 완료 후 제거 필요
    func showPopup(text: String, subText: String, keywrod: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String)
    func showSimilarChefList()
    func showSearch()
    func showNotification()
    func showAllContents()
    func showAreaSelection()
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
    
    // TODO: 회원가입 api 연동 완료 후 제거 필요
    func showSNSLoginView() {
        actions?.showSNSLoginView()
    }
    
    func showPopup(text: String, subText: String, keywrod: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String) {
        actions?.showPopup(text, subText, keywrod, popupState, leftButtonTitle, rightButtonTitle, nil, nil)
    }
    
    func showSimilarChefList() {
        actions?.showSimilarChefList()
    }
    
    func showSearch() {
        actions?.showSearch()
    }
    
    func showAllContents() {
        actions?.showAllCheffiContents()
    }

    func showNotification() {
        actions?.showNotification()
    }

    func showAreaSelection() {
        actions?.showAreaSelection()
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
