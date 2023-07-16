//
//  SimilarChefViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import Foundation
import Combine


protocol SimilarChefViewModelInput {
    var selectedCategory: PassthroughSubject<String, Error> { get }
}

protocol SimilarChefViewModelOutput {
    var combinedData: AnyPublisher<([String], [User]), Error> { get }
}

final class SimilarChefViewModel: SimilarChefViewModelInput & SimilarChefViewModelOutput {
    
    private var cancellables = Set<AnyCancellable>()
    private let fetchSimilarChefUseCase: FetchSimilarChefUseCase
    private let repository: SimilarChefRepository
    private var _profiles = PassthroughSubject<[User], Error>()
    
    // MARK: - Input
    var selectedCategory = PassthroughSubject<String, Error>()
    
    // MARK: - Output
    var combinedData: AnyPublisher<([String], [User]), Error> {
        Publishers.Zip(repository.getCategories(), _profiles)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(fetchSimilarChefUseCase: FetchSimilarChefUseCase, repository: SimilarChefRepository) {
        self.fetchSimilarChefUseCase = fetchSimilarChefUseCase
        self.repository = repository
        
        selectedCategory
            .flatMap(fetchSimilarChefUseCase.execute)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    debugPrint("------------------------------------------")
                    debugPrint(error)
                    debugPrint("------------------------------------------")
                }
            }, receiveValue: { [weak self] profiles in
                self?._profiles.send(profiles)
            })
            .store(in: &cancellables)
    }
}
