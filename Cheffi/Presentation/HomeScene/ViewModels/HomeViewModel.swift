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
}

final class HomeViewModel: HomeViewModelInput & HomeViewModelOutput {
    private var cancellables = Set<AnyCancellable>()
    private let actions: HomeViewModelActions?
    
    // MARK: - Input
    
    // MARK: - Output
    var similarChefViewModel: SimilarChefViewModel
    
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
        similarChefViewModel: SimilarChefViewModel
    ) {
        self.actions = actions
        self.similarChefViewModel = similarChefViewModel
    }
}
