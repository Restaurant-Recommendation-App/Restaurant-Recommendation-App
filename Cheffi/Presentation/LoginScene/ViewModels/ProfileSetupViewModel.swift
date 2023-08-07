//
//  ProfileSetupViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import Foundation
import Combine

protocol ProfileSetupViewModelInput {
    var nextButtonTapped: PassthroughSubject<Void, Never> { get }
    var previousButtonTapped: PassthroughSubject<Void, Never> { get }
}

protocol ProfileSetupViewModelOutput {
    var progress: AnyPublisher<Float, Never> { get }
    var currentPage: CurrentValueSubject<Int, Never> { get }
}

final class ProfileSetupViewModel: ProfileSetupViewModelInput & ProfileSetupViewModelOutput {
    var input: ProfileSetupViewModelInput { return self }
    var output: ProfileSetupViewModelOutput { return self }
    
    private var cancellables = Set<AnyCancellable>()
    private let totalPages = 5
    
    // MARK: - Input
    let nextButtonTapped = PassthroughSubject<Void, Never>()
    let previousButtonTapped = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    var currentPage = CurrentValueSubject<Int, Never>(0)
    
    var progress: AnyPublisher<Float, Never> {
        return currentPage
            .map { Float($0 + 1) / Float(self.totalPages) }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init() {
        nextButtonTapped
            .sink { [weak self] in
                if self?.currentPage.value ?? 0 < self?.totalPages ?? 0 {
                    self?.currentPage.value += 1
                }
            }
            .store(in: &cancellables)
        
        previousButtonTapped
            .sink { [weak self] in
                if self?.currentPage.value ?? 0 > 0 {
                    self?.currentPage.value -= 1
                }
            }
            .store(in: &cancellables)
    }
}
