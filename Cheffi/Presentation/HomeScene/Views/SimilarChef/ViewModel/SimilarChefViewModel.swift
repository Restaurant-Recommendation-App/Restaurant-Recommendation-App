//
//  SimilarChefViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import Foundation
import Combine


protocol SimilarChefViewModelInput {
    var selectedCategory: PassthroughSubject<String, Never> { get }
}

protocol SimilarChefViewModelOutput {
    var categories: AnyPublisher<[String], Never> { get }
    var profiles: AnyPublisher<[String], Never> { get }
}

final class SimilarChefViewModel: SimilarChefViewModelInput & SimilarChefViewModelOutput {
    
    private var cancellables = Set<AnyCancellable>()
    private var _profiles = PassthroughSubject<[String], Never>()
    
    // MARK: - Input
    var selectedCategory = PassthroughSubject<String, Never>()
    
    // MARK: - Output
    var categories: AnyPublisher<[String], Never> {
        Just(["한식", "노포", "아시아음식", "매운맛", "천절함", "한식", "노포", "아시아음식", "매운맛", "천절함"])
            .eraseToAnyPublisher()
    }
    var profiles: AnyPublisher<[String], Never> {
            _profiles.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init() {
        selectedCategory
            .flatMap { category in
                Just(["김맛집1", "김맛집2", "김맛집3", "김맛집4", "김맛집5", "김맛집6", "김맛집7", "김맛집8", "김맛집9", "김맛집10", "김맛집11", "김맛집12", "김맛집13", "김맛집14"])
                    .map { Array($0.prefix(12)) }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] profiles in
                self?._profiles.send(profiles)
            }
            .store(in: &cancellables)
    }
}
