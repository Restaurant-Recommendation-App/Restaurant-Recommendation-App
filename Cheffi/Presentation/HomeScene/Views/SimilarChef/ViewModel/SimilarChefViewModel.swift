//
//  SimilarChefViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import Foundation
import Combine


protocol SimilarChefViewModelInput {
    var selectedCategories: PassthroughSubject<[String], Error> { get }
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
    var selectedCategories = PassthroughSubject<[String], Error>()
    
    // MARK: - Output
    var combinedData: AnyPublisher<([String], [User]), Error> {
        Publishers.Zip(repository.getCategories(), _profiles)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(fetchSimilarChefUseCase: FetchSimilarChefUseCase, repository: SimilarChefRepository) {
        self.fetchSimilarChefUseCase = fetchSimilarChefUseCase
        self.repository = repository
        
        selectedCategories
            .flatMap({ [weak self] categories in
                self?.saveCategories(categories)
                return fetchSimilarChefUseCase.execute(categories: categories)
            })
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // TODO: Error 헨들링
                    debugPrint("------------------------------------------")
                    debugPrint(error)
                    debugPrint("------------------------------------------")
                }
            }, receiveValue: { [weak self] profiles in
                self?._profiles.send(profiles)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Private
    private func saveCategories(_ categories: [String]) {
        UserDefaultsManager.HomeSimilarChefInfo.categories = categories
    }
}
