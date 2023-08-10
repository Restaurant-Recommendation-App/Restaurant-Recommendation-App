//
//  SearchViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import Foundation
import Combine

protocol SearchViewModelInput {
    var searchText: PassthroughSubject<String, Never> { get }
}

protocol SearchViewModelOutput {
    var recentSearches: AnyPublisher<[String], Never> { get }
    var recommendSearches: AnyPublisher<[String], Never> { get }
    var topPicks: AnyPublisher<[String], Never> { get }
}

final class SearchViewModel: SearchViewModelInput & SearchViewModelOutput {
    // Input
    let searchText = PassthroughSubject<String, Never>()
    
    // Output
    @Published private var _recentSearches: [String] = []
    @Published private var _recommendSearches: [String] = []
    @Published private var _topPicks: [String] = []
    
    var recentSearches: AnyPublisher<[String], Never> {
        return $_recentSearches.eraseToAnyPublisher()
    }
    var recommendSearches: AnyPublisher<[String], Never> {
        return $_recommendSearches.eraseToAnyPublisher()
    }
    var topPicks: AnyPublisher<[String], Never> {
        return $_topPicks.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        searchText
            .sink { [weak self] text in
                self?.fetchSearchResults(for: text)
            }
            .store(in: &cancellables)
    }
    
    private func fetchSearchResults(for searchText: String) {
        // TODO: 검색 로직을 구현하고 최근 검색, 추천 검색 및 상위 추천을 업데이트
    }
    
    
    func loadInitialData() {
        DispatchQueue.main.async { [weak self] in
            self?._recentSearches = UserDefaultsManager.SearchInfo.keywords
        }
    }
}
