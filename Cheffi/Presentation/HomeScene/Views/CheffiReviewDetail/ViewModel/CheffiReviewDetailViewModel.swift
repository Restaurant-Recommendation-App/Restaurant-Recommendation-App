//
//  CheffiReviewViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation
import Combine

protocol CheffiReviewDetailViewModelInput {
    func selectReviewState(_ state: ReviewState)
    func requestGetReview()
    func requestPostavaterFollow(id: Int)
    func requestDeletAvatarFollow(id: Int)
}

protocol CheffiReviewDetailViewModelOutput {
    var selectedReviewState: AnyPublisher<ReviewState?, Never> { get }
    var reviewInfo: AnyPublisher<GetReviewResponse?, DataTransferError> { get }
}

protocol CheffiReviewDetailViewModelType {
    var input: CheffiReviewDetailViewModelInput { get }
    var output: CheffiReviewDetailViewModelOutput { get }
}

class CheffiReviewDetailViewModel: CheffiReviewDetailViewModelType {
    var input: CheffiReviewDetailViewModelInput { return self }
    var output: CheffiReviewDetailViewModelOutput { return self }
    
    private let _selectReviewState = PassthroughSubject<ReviewState, Never>()
    @Published private var _selectedReviewState: ReviewState? = nil
    private var cancellables = Set<AnyCancellable>()
    private var getReviewSubject = PassthroughSubject<Int, Never>()

    // MARK: - Init
    private let reviewId: Int
    private let useCase: ReviewUseCase
    init(reviewId: Int, useCase: ReviewUseCase) {
        self.reviewId = reviewId
        self.useCase = useCase
        bind()
    }
    
    // MARK: - Private
    private func bind() {
        _selectReviewState
            .sink { [weak self] state in
                if self?._selectedReviewState == state {
                    self?._selectedReviewState = nil
                } else {
                    self?._selectedReviewState = state
                }
            }
            .store(in: &cancellables)
    }
    
    private func getReview(reviewId: Int) -> AnyPublisher<GetReviewResponse?, DataTransferError> {
        let subject = PassthroughSubject<GetReviewResponse?, DataTransferError>()
        useCase.getReviews(reviewRequest: ReviewRequest(id: reviewId))
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

// MARK: - Inputs
extension CheffiReviewDetailViewModel: CheffiReviewDetailViewModelInput {
    func selectReviewState(_ state: ReviewState) {
        _selectReviewState.send(state)
    }
    
    func requestGetReview() {
        getReviewSubject.send(self.reviewId)
    }
    
    func requestPostavaterFollow(id: Int) {
        print("---------------------------------------")
        print("팔로우 신청")
        print("---------------------------------------")
    }
    
    func requestDeletAvatarFollow(id: Int) {
        print("---------------------------------------")
        print("팔로우 취소")
        print("---------------------------------------")
    }
}

// MARK: - Outputs
extension CheffiReviewDetailViewModel: CheffiReviewDetailViewModelOutput {
    var selectedReviewState: AnyPublisher<ReviewState?, Never> {
        return $_selectedReviewState.eraseToAnyPublisher()
    }
    
    var reviewInfo: AnyPublisher<GetReviewResponse?, DataTransferError> {
        return getReviewSubject
            .flatMap { [weak self] reviewId -> AnyPublisher<GetReviewResponse?, DataTransferError> in
                guard let self else {
                    return Future { promise in
                        promise(.success(nil))
                    }.eraseToAnyPublisher()
                }
                return self.getReview(reviewId: reviewId)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
