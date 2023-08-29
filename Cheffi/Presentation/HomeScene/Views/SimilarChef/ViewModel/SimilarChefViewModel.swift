//
//  SimilarChefViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import Foundation
import Combine


protocol SimilarChefViewModelInput {
    func selectTags(_ tags: [String])
}

protocol SimilarChefViewModelOutput {
    var combinedData: AnyPublisher<([String], [User]), Never> { get }
}

final class SimilarChefViewModel: SimilarChefViewModelInput & SimilarChefViewModelOutput {
    
    private var cancellables = Set<AnyCancellable>()
    private let similarChefUseCase: SimilarChefUseCase
    private let repository: SimilarChefRepository
    private let _selectedTags = PassthroughSubject<[String], Never>()
    private let _profiles = PassthroughSubject<[User], Never>()
    
    // MARK: - Input
    func selectTags(_ tags: [String]) {
        _selectedTags.send(tags)
    }
    
    // MARK: - Output
    var combinedData: AnyPublisher<([String], [User]), Never> {
        return Publishers.Zip(_selectedTags, _profiles)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(
        similarChefUseCase: SimilarChefUseCase,
        repository: SimilarChefRepository
    ) {
        self.similarChefUseCase = similarChefUseCase
        self.repository = repository
        
        _selectedTags
            .flatMap({ [weak self] tags in
                self?.saveTags(tags)
                return similarChefUseCase.execute(tags: tags)
                    .catch { error -> Empty<[User], Never> in
                        debugPrint("------------------------------------------")
                        debugPrint(error)
                        debugPrint("------------------------------------------")
                        return .init()
                    }
            })
            .sink(receiveValue: { [weak self] profiles in
                self?._profiles.send(profiles)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Private
    private func saveTags(_ tags: [String]) {
        UserDefaultsManager.HomeSimilarChefInfo.tags = tags
    }
}
