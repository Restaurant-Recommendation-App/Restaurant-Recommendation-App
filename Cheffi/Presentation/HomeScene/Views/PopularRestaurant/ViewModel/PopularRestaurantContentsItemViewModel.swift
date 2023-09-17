//
//  PopularRestaurantContentsItemViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/09/06.
//

import Combine
import Foundation

final class PopularRestaurantContentsItemViewModel: ViewModelType {
    
    struct Input {
        let initialize: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let contentItems: AnyPublisher<[RestaurantContentItemViewModel], Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    let items: [RestaurantContentItemViewModel]

    init(items: [RestaurantContentItemViewModel]) {
        self.items = items
    }
    
    func transform(input: Input) -> Output {
        
        let contentItems = PassthroughSubject<[RestaurantContentItemViewModel], Never>()
        
        input.initialize
            .sink {
                contentItems.send(self.items)
            }.store(in: &cancellables)
        
        return Output(contentItems: contentItems.eraseToAnyPublisher())
    }
}

extension PopularRestaurantContentsItemViewModel: Identifiable, Hashable {
    var identifier: String {
        return UUID().uuidString
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: PopularRestaurantContentsItemViewModel, rhs: PopularRestaurantContentsItemViewModel) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
