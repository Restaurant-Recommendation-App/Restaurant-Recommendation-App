//
//  SimilarChefViewModel.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import Foundation
import Combine


protocol SimilarChefViewModelInput {
    func requestGetTags(type: TagType)
    func selectTags(_ tags: [String])
}

protocol SimilarChefViewModelOutput {
    var combinedData: AnyPublisher<([String], [User]), Never> { get }
}

protocol SimilarChefViewModelType {
    var input: SimilarChefViewModelInput { get }
    var output: SimilarChefViewModelOutput { get }
}

final class SimilarChefViewModel: SimilarChefViewModelType {
    var input: SimilarChefViewModelInput { return self }
    var output: SimilarChefViewModelOutput { return self }
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: SimilarChefUseCase
    private let _selectedTags = PassthroughSubject<[String], Never>()
    private let _profiles = PassthroughSubject<[User], Never>()
    
    // MARK: - Init
    init(useCase: SimilarChefUseCase) {
        self.useCase = useCase
        
        _selectedTags
            .flatMap({ [weak self] tags in
                self?.saveTags(tags)
                return useCase.getUsers(tags: tags)
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
    
    private func requestGetUsers(tags: [String]) -> AnyPublisher<[User], DataTransferError> {
        let subject = PassthroughSubject<[User], DataTransferError>()
        useCase.getUsers(tags: tags)
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { users in
                subject.send(users)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Input
extension SimilarChefViewModel: SimilarChefViewModelInput {
    func requestGetTags(type: TagType) {
        useCase.getTags(type: type)
            .print()
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("---------------------------------------")
                    print("requestGetTags error : \(error)")
                    print("---------------------------------------")
                }
            } receiveValue: { [weak self] (tags, _) in
                self?._selectedTags.send(tags.map({ $0.name }))
            }
            .store(in: &cancellables)
    }
    
    func selectTags(_ tags: [String]) {
        _selectedTags.send(tags)
    }
}

// MARK: - Output
extension SimilarChefViewModel: SimilarChefViewModelOutput {
    var combinedData: AnyPublisher<([String], [User]), Never> {
        return Publishers.Zip(_selectedTags, _profiles)
            .eraseToAnyPublisher()
    }
}
