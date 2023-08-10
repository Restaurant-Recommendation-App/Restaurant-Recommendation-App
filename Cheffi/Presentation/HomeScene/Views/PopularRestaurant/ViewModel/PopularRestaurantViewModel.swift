//
//  PopularRestaurantViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/01.
//

import Foundation
import Combine

final class PopularRestaurantViewModel: ViewModelType {
    
    private var numberOfContentsToShow: Int
    
    struct Input {
        let initialize: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let models: AnyPublisher<[RestaurantContentsViewModel], Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    init(numberOfContentsToShow: Int) {
        self.numberOfContentsToShow = numberOfContentsToShow
    }
    
    func transform(input: Input) -> Output {
        let models = PassthroughSubject<[RestaurantContentsViewModel], Never>()
        
        input.initialize.sink { _ in
            // TODO: Usecase 활용
            models.send(Array(popularRestaurantContentsViewModelMock[0][0 ..< self.numberOfContentsToShow]))
        }.store(in: &cancellables)

        return Output(models: models.eraseToAnyPublisher())
    }
}


