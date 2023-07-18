//
//  HomeViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

protocol HomeViewModelInput {
    var selectedCategory: PassthroughSubject<Void, Never> { get }
}

protocol HomeViewModelOutput {
    var similarChefViewModel: SimilarChefViewModel { get }
}

final class HomeViewModel: HomeViewModelInput & HomeViewModelOutput {
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    var selectedCategory = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    var similarChefViewModel: SimilarChefViewModel

    // MARK: - Init
    init(similarChefViewModel: SimilarChefViewModel) {
        self.similarChefViewModel = similarChefViewModel

        selectedCategory
            .sink { [weak self] _ in
                self?.similarChefViewModel.selectedCategory.send("")
            }
            .store(in: &cancellables)
    }
}
