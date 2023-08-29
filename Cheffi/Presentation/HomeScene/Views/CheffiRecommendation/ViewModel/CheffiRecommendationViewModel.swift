//
//  CheffiRecommendationViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/01.
//

import Combine
import Foundation

final class CheffiRecommendationViewModel: ViewModelType {
    
    struct Input {
        let initialize: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let categories: AnyPublisher<([String], [RestaurantContentsViewModel]), Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    var initialized = false
            
    private let cheffiRecommendationUseCase: CheffiRecommendationUseCase
            
    init(cheffiRecommendationUseCase: CheffiRecommendationUseCase) {
        self.cheffiRecommendationUseCase = cheffiRecommendationUseCase
    }
        
    func transform(input: Input) -> Output {
        cancellables.forEach {
            $0.cancel()
        }
        cancellables =  Set<AnyCancellable>()
        
        let categories = PassthroughSubject<([String], [RestaurantContentsViewModel]), Never>()
        
        // TODO: Usecase 활용 필요
        input.initialize
            .filter { !self.initialized }
            .flatMap { self.cheffiRecommendationUseCase.getTags() }
            .sink { tags in
                let viewModels = tags.map {
                    RestaurantContentsViewModel(
                        tag: $0,
                        cheffiRecommendationUseCase: self.cheffiRecommendationUseCase
                    )
                }
                categories.send((tags, viewModels))
                self.initialized = true
            }.store(in: &cancellables)

        return Output(
            categories: categories.eraseToAnyPublisher()
        )
    }
}
