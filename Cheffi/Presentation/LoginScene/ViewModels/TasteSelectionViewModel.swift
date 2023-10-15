//
//  TasteSelectionViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/14/23.
//

import Foundation
import Combine

protocol TasteSelectionViewModelInput {
    func requestGetTags(type: TagType)
    func requestPutTags()
    func setFoodSelectionTags(_ tags: [Tag])
    func setTasteSelectionTags(_ tags: [Tag])
}

protocol TasteSelectionViewModelOutput {
    var responseTags: AnyPublisher<[Tag], DataTransferError> { get }
    var updateCompletionTags: AnyPublisher<TagsChangeResponse?, DataTransferError> { get }
}

protocol TasteSelectionViewModelType {
    var input: TasteSelectionViewModelInput { get }
    var output: TasteSelectionViewModelOutput { get }
}

class TasteSelectionViewModel: TasteSelectionViewModelType {
    var input: TasteSelectionViewModelInput { return self }
    var output: TasteSelectionViewModelOutput { return self }
    
    private var cancellables: Set<AnyCancellable> = []
    private var getTagsSubject = PassthroughSubject<TagType, Never>()
    private var putTagsSubject = PassthroughSubject<Void, Never>()
    private var _foodSelectionTags: [Tag] = []
    private var _tasteSelectionTags: [Tag] = []
    
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
    
    private func putTags() -> AnyPublisher<TagsChangeResponse?, DataTransferError> {
        let subject = PassthroughSubject<TagsChangeResponse?, DataTransferError>()
        let tagRequest = TagsChangeRequest(foodTags: _foodSelectionTags.map({ $0.id }),
                                          tasteTags: _tasteSelectionTags.map({ $0.id }))
        useCase.putTags(tagRequest: tagRequest)
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { tagResponse in
                subject.send(tagResponse)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Input
extension TasteSelectionViewModel: TasteSelectionViewModelInput {
    func requestGetTags(type: TagType) {
        getTagsSubject.send(type)
    }
    
    func requestPutTags() {
        putTagsSubject.send(())
    }
    
    func setFoodSelectionTags(_ tags: [Tag]) {
        self._foodSelectionTags = tags
    }
    
    func setTasteSelectionTags(_ tags: [Tag]) {
        self._tasteSelectionTags = tags
    }
}

// MARK: - Output
extension TasteSelectionViewModel: TasteSelectionViewModelOutput {
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
    
    var updateCompletionTags: AnyPublisher<TagsChangeResponse?, DataTransferError> {
        return putTagsSubject
            .flatMap { [weak self] type -> AnyPublisher<TagsChangeResponse?, DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success(nil))
                    }.eraseToAnyPublisher()
                }
                
                return self.putTags()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

