//
//  FoodSelectionViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/14/23.
//

import Foundation
import Combine

protocol FoodSelectionViewModelInput {
    func requestGetTags(type: TagType)
    func setSelectionTags(_ tags: [Tag])
}

protocol FoodSelectionViewModelOutput {
    var responseTags: AnyPublisher<[Tag], DataTransferError> { get }
    var selectionTags: [Tag] { get }
}

protocol FoodSelectionViewModelType {
    var input: FoodSelectionViewModelInput { get }
    var output: FoodSelectionViewModelOutput { get }
}

class FoodSelectionViewModel: FoodSelectionViewModelType {
    var input: FoodSelectionViewModelInput { return self }
    var output: FoodSelectionViewModelOutput { return self }
    
    private var cancellables: Set<AnyCancellable> = []
    private var getTagsSubject = PassthroughSubject<TagType, Never>()
    private var _selectionTags: [Tag] = []
    
    // MARK: - Init
    private let useCase: TagUseCase
    init(useCase: TagUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Private
    private func getTags(type: TagType) -> AnyPublisher<[Tag], DataTransferError> {
        let subject = PassthroughSubject<[Tag], DataTransferError>()
        useCase.getTags(type: type)
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { tags in
                subject.send(tags)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Input
extension FoodSelectionViewModel: FoodSelectionViewModelInput {
    func requestGetTags(type: TagType) {
        getTagsSubject.send(type)
    }
    
    func setSelectionTags(_ tags: [Tag]) {
        self._selectionTags = tags
    }
}

// MARK: - Output
extension FoodSelectionViewModel: FoodSelectionViewModelOutput {
    var responseTags: AnyPublisher<[Tag], DataTransferError> {
        return getTagsSubject
            .flatMap { [weak self] type -> AnyPublisher<[Tag], DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success([]))
                    }.eraseToAnyPublisher()
                }
                return self.getTags(type: type)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var selectionTags: [Tag] {
        return _selectionTags
    }
}
