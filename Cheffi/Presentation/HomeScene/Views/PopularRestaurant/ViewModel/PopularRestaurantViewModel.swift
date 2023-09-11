//
//  PopularRestaurantViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/01.
//

import Foundation
import Combine

final class PopularRestaurantViewModel: ViewModelType {
    
    struct Input {
        let initialize: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let contentsViewModel: AnyPublisher<[PopularRestaurantContentsItemViewModel], Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    private let cheffiRecommendationUseCase: CheffiRecommendationUseCase
    
    private var initialized = false
    
    init(cheffiRecommendationUseCase: CheffiRecommendationUseCase) {
        self.cheffiRecommendationUseCase = cheffiRecommendationUseCase
    }
    
    func transform(input: Input) -> Output {        
        let contentsViewModel = PassthroughSubject<[PopularRestaurantContentsItemViewModel], Never>()
        
        input.initialize
            .filter { !self.initialized }
            .flatMap { self.cheffiRecommendationUseCase.getContents(with: "popularity", page: 1) }
            .map { $0.map(RestaurantContentItemViewModel.init)}
            .sink {
                var first = [[RestaurantContentItemViewModel]]([[RestaurantContentItemViewModel]($0[0...2])])
                let rest = $0[3..<$0.count].group(by: 4)!
                first += rest
                
                var viewModels = [PopularRestaurantContentsItemViewModel]()
                first.forEach {
                    viewModels.append(PopularRestaurantContentsItemViewModel(items: $0))
                }
                
                contentsViewModel.send(viewModels)
                self.initialized = true
        }.store(in: &cancellables)

        return Output(contentsViewModel: contentsViewModel.eraseToAnyPublisher())
    }
}


