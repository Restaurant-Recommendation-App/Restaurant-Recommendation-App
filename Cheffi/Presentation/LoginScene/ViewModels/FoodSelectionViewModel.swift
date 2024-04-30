//
//  FoodSelectionViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/14/23.
//

import Foundation
import Combine

protocol FoodSelectionViewModelInput {
    func requestGetTags(type: TagTypeRequest)
    func requestPutTags()
    func setSelectionTags(_ tags: [Tag])
}

protocol FoodSelectionViewModelOutput {
    var responseTags: AnyPublisher<[Tag], DataTransferError> { get }
    var updateCompletionTags: AnyPublisher<TagsChangeResponse?, DataTransferError> { get }
}

protocol FoodSelectionViewModelType {
    var input: FoodSelectionViewModelInput { get }
    var output: FoodSelectionViewModelOutput { get }
}

class FoodSelectionViewModel: FoodSelectionViewModelType {
    var input: FoodSelectionViewModelInput { return self }
    var output: FoodSelectionViewModelOutput { return self }
    
    private var cancellables: Set<AnyCancellable> = []
    private var getTagsSubject = PassthroughSubject<TagTypeRequest, Never>()
    private var putTagsSubject = PassthroughSubject<Void, Never>()
    private var _selectionTags: [Tag] = []
    
    // MARK: - Init
    private let useCase: TagUseCase
    init(useCase: TagUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Private
    private func getTags(type: TagTypeRequest) -> AnyPublisher<[Tag], DataTransferError> {
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
        let tagRequest = ProfileTagsChangeRequest(ids: _selectionTags.map({ $0.id }), type: .food)
        
        useCase.putTags(tagRequest: tagRequest)
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    // TODO: 중복 태그 요청 에러 대응 필요
                    subject.send(nil)
//                    subject.send(completion: .failure(error))
                }
            } receiveValue: { tagResponse in
                subject.send(tagResponse)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Input
extension FoodSelectionViewModel: FoodSelectionViewModelInput {
    func requestGetTags(type: TagTypeRequest) {
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
