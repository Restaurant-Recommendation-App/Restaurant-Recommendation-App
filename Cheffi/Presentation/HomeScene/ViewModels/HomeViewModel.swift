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
}

protocol HomeViewModelInput {
    var selectedCategory: PassthroughSubject<Void, Never> { get }
}

protocol HomeViewModelOutput {
    var similarChefViewModel: SimilarChefViewModel { get }
}

final class HomeViewModel: HomeViewModelInput & HomeViewModelOutput {
    private var cancellables = Set<AnyCancellable>()
    private let actions: HomeViewModelActions?
    
    // MARK: - Input
    var selectedCategory = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    var similarChefViewModel: SimilarChefViewModel
    
    func showPopup(text: String, keywrod: String) {
        actions?.showPopup(text, keywrod)
    }
    
    func showSimilarChefList() {
    }

    // MARK: - Init
    init(
        actions: HomeViewModelActions,
        similarChefViewModel: SimilarChefViewModel
    ) {
        self.actions = actions
        self.similarChefViewModel = similarChefViewModel

        selectedCategory
            .sink { [weak self] _ in
                self?.similarChefViewModel.selectedCategory.send("")
            }
            .store(in: &cancellables)
    }
}
