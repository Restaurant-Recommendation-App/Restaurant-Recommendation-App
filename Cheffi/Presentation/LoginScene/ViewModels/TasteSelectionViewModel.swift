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
    func setSelectionTags(_ tags: [Tag])
}

protocol TasteSelectionViewModelOutput {
    var responseTags: AnyPublisher<[Tag], DataTransferError> { get }
    var updateCompletionTags: AnyPublisher<[String], DataTransferError> { get }
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
    
    private func putTags() -> AnyPublisher<[String], DataTransferError> {
        let tagRequest = TestTagsChangeRequest(ids: _selectionTags.map({ $0.id }), type: .taste)
        
        return useCase.putTags(tagRequest: tagRequest)
            .flatMap { _ in self.postRegisterProfile() }
            .eraseToAnyPublisher()
    }
    
    private func postRegisterProfile() -> AnyPublisher<[String], DataTransferError> {
        let subject = PassthroughSubject<[String], DataTransferError>()
        useCase.postRegisterUserProfile()
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { results in
                subject.send(results)
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
    
    func setSelectionTags(_ tags: [Tag]) {
        self._selectionTags = tags
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
    
    var updateCompletionTags: AnyPublisher<[String], DataTransferError> {
        return putTagsSubject
            .flatMap { [weak self] type -> AnyPublisher<[String], DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success([]))
                    }.eraseToAnyPublisher()
                }
                
                return self.putTags()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

