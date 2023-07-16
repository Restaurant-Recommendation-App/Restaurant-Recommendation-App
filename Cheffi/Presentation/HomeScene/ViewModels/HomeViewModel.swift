//
//  HomeViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/16.
//

import Foundation
import Combine

protocol HomeViewModelInput {
    var viewDidAppear: PassthroughSubject<Void, Never> { get }
}

protocol HomeViewModelOutput {
    var similarChefViewModel: SimilarChefViewModel { get }
}

final class HomeViewModel: HomeViewModelInput & HomeViewModelOutput {
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    var viewDidAppear = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    var similarChefViewModel: SimilarChefViewModel

    // MARK: - Init
    init(similarChefViewModel: SimilarChefViewModel) {
        self.similarChefViewModel = similarChefViewModel

        viewDidAppear
            .sink { [weak self] _ in
                self?.similarChefViewModel.selectedCategory.send("")
            }
            .store(in: &cancellables)
    }
}
