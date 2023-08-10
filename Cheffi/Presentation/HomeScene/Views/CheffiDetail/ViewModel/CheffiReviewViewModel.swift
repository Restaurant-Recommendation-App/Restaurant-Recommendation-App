//
//  CheffiReviewViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import Foundation
import Combine

protocol CheffiReviewViewModelInput {
    func selectReviewState(_ state: ReviewState)
}

protocol CheffiReviewViewModelOutput {
    var selectedReviewState: AnyPublisher<ReviewState?, Never> { get }
}

class CheffiReviewViewModel: CheffiReviewViewModelInput, CheffiReviewViewModelOutput {
    // MARK: - Inputs
    private let _selectReviewState = PassthroughSubject<ReviewState, Never>()

    // MARK: - Outputs
    var selectedReviewState: AnyPublisher<ReviewState?, Never> {
        $_selectedReviewState.eraseToAnyPublisher()
    }
    
    @Published private var _selectedReviewState: ReviewState? = nil

    private var cancellables = Set<AnyCancellable>()

    init() {
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
    
    // MARK: - CheffiReviewViewModelInput
    func selectReviewState(_ state: ReviewState) {
        _selectReviewState.send(state)
    }
}

