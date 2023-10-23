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
    func setSelectTags(_ tags: [Tag])
}

protocol SimilarChefViewModelOutput {
    var combinedData: AnyPublisher<([Tag], [User]), DataTransferError> { get }
    var tags: AnyPublisher<[Tag], Never> { get }
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
    private let selectedTagSubject = PassthroughSubject<[Tag], Never>()
    private let _tagsSubject = PassthroughSubject<[Tag], Never>()
    private let getTagsSubject = PassthroughSubject<TagType, Never>()
    private let getUsersSubject = PassthroughSubject<[String], Never>()
    private let _users = PassthroughSubject<[User], Never>()
    
    // MARK: - Init
    init(useCase: SimilarChefUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Private
    private func saveTags(_ tags: [Tag]) {
        UserDefaultsManager.HomeSimilarChefInfo.tags = tags
    }
    
    private func getTags(type: TagType) -> AnyPublisher<[Tag], DataTransferError> {
        let subject = PassthroughSubject<[Tag], DataTransferError>()
        useCase.getTags(type: type)
            .print()
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("---------------------------------------")
                    print("getTags error : \(error)")
                    print("---------------------------------------")
                }
            } receiveValue: { [weak self] results in
                self?._tagsSubject.send(results)
                subject.send(results)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
    
    private func getUsers(tags: [String]) -> AnyPublisher<[User], DataTransferError> {
        let mockUsers: [User] = [
            User(email: "", locked: false, expired: false, activated: true, nickname: "nickname1", name: "name1", userType: .kakao, adAgreed: true, analysisAgreed: true, cheffiCoinCount: 100, pointCount: 100, photoURL: nil, isNewUser: false, profileCompleted: true),
            User(email: "", locked: false, expired: false, activated: true, nickname: "nickname2", name: "name2", userType: .kakao, adAgreed: true, analysisAgreed: true, cheffiCoinCount: 100, pointCount: 100, photoURL: nil, isNewUser: false, profileCompleted: true),
            User(email: "", locked: false, expired: false, activated: true, nickname: "nickname3", name: "name3", userType: .kakao, adAgreed: true, analysisAgreed: true, cheffiCoinCount: 100, pointCount: 100, photoURL: nil, isNewUser: false, profileCompleted: true),
            User(email: "", locked: false, expired: false, activated: true, nickname: "nickname4", name: "name4", userType: .kakao, adAgreed: true, analysisAgreed: true, cheffiCoinCount: 100, pointCount: 100, photoURL: nil, isNewUser: false, profileCompleted: true),
            User(email: "", locked: false, expired: false, activated: true, nickname: "nickname5", name: "name5", userType: .kakao, adAgreed: true, analysisAgreed: true, cheffiCoinCount: 100, pointCount: 100, photoURL: nil, isNewUser: false, profileCompleted: true),
            User(email: "", locked: false, expired: false, activated: true, nickname: "nickname6", name: "name6", userType: .kakao, adAgreed: true, analysisAgreed: true, cheffiCoinCount: 100, pointCount: 100, photoURL: nil, isNewUser: false, profileCompleted: true),
            User(email: "", locked: false, expired: false, activated: true, nickname: "nickname7", name: "name7", userType: .kakao, adAgreed: true, analysisAgreed: true, cheffiCoinCount: 100, pointCount: 100, photoURL: nil, isNewUser: false, profileCompleted: true),
            User(email: "", locked: false, expired: false, activated: true, nickname: "nickname8", name: "name8", userType: .kakao, adAgreed: true, analysisAgreed: true, cheffiCoinCount: 100, pointCount: 100, photoURL: nil, isNewUser: false, profileCompleted: true)
        ]
        
        return Just(mockUsers)
            .setFailureType(to: DataTransferError.self)
            .eraseToAnyPublisher()
        
        // 서버 API 구현이 되어있지 않아서 mock 데이터로 대체
//        let subject = PassthroughSubject<[User], DataTransferError>()
//        useCase.getUsers(tags: tags)
//            .print()
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    subject.send(completion: .finished)
//                case .failure(let error):
//                    subject.send(completion: .failure(error))
//                }
//            } receiveValue: { users in
//                subject.send(users)
//            }
//            .store(in: &cancellables)
//        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Input
extension SimilarChefViewModel: SimilarChefViewModelInput {
    func requestGetTags(type: TagType) {
        getTagsSubject.send(type)
    }
    
    func setSelectTags(_ tags: [Tag]) {
        selectedTagSubject.send(tags)
    }
}

// MARK: - Output
extension SimilarChefViewModel: SimilarChefViewModelOutput {
    var tags: AnyPublisher<[Tag], Never> {
        return _tagsSubject
            .prefix(1)
            .eraseToAnyPublisher()
    }
    
    var combinedData: AnyPublisher<([Tag], [User]), DataTransferError> {
        let tagsPublisher = getTagsSubject
            .flatMap { [weak self] type -> AnyPublisher<[Tag], DataTransferError> in
                guard let self else {
                    return Future { promise in
                        promise(.success([]))
                    }.eraseToAnyPublisher()
                }
                return self.getTags(type: type)
            }
            .share()
            .eraseToAnyPublisher()
        
        let usersPublisher = selectedTagSubject
            .flatMap { [weak self] selectedTags -> AnyPublisher<[User], DataTransferError> in
                guard let self, !selectedTags.isEmpty else {
                    return Just([]).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
                }
                
                self.saveTags(selectedTags)
                return self.getUsers(tags: selectedTags.map({ $0.name }))
            }
            .eraseToAnyPublisher()
        
        return Publishers.CombineLatest(tagsPublisher, usersPublisher)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
