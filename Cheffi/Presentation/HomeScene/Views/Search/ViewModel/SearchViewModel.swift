//
//  SearchViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import Foundation
import Combine

final class SearchViewModel: ViewModelType {
    
    struct Input {
        let initialize: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let recentSearches: AnyPublisher<[[String]], Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    private let searchUseCase: SearchUseCase
    
    init(searchUseCase: SearchUseCase) {
        self.searchUseCase = searchUseCase
    }

    func transform(input: Input) -> Output {
        let recentSearches = PassthroughSubject<[[String]], Never>()
                
        input.initialize
            .zip(searchUseCase.getRecentSearch(withCategory: SearchCategory.food),
                 searchUseCase.getRecentSearch(withCategory: SearchCategory.area)
            ).sink {
                recentSearches.send([$1, $2])
            }.store(in: &cancellables)
        
        return Output(
            recentSearches: recentSearches.eraseToAnyPublisher()
        )
    }
}
