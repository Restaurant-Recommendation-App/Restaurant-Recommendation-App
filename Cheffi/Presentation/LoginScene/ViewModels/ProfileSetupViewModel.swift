//
//  ProfileSetupViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import Foundation
import Combine

protocol ProfileSetupViewModelInput {
    var nextButtonTapped: PassthroughSubject<[ProfilePageKey: Any], Never> { get }
    var previousButtonTapped: PassthroughSubject<Void, Never> { get }
    func setParams(_ params: [ProfilePageKey: Any])
}

protocol ProfileSetupViewModelOutput {
    var progress: AnyPublisher<Float, Never> { get }
    var currentPage: CurrentValueSubject<Int, Never> { get }
    var params: [ProfilePageKey: Any] { get }
}

protocol ProfileSetupViewModelType {
    var input: ProfileSetupViewModelInput { get }
    var output: ProfileSetupViewModelOutput { get }
}


final class ProfileSetupViewModel: ProfileSetupViewModelType {
    var input: ProfileSetupViewModelInput { return self }
    var output: ProfileSetupViewModelOutput { return self }
    
    private var cancellables = Set<AnyCancellable>()
    private let totalPages = 5
    private var _params: [ProfilePageKey: Any] = [:]
    
    // MARK: - Init
    var nextButtonTapped = PassthroughSubject<[ProfilePageKey: Any], Never>()
    var previousButtonTapped = PassthroughSubject<Void, Never>()
    var currentPage = CurrentValueSubject<Int, Never>(0)
    init() {
        self.setup()
    }
    
    private func setup() {
        nextButtonTapped
            .sink { [weak self] params in
                params.forEach { self?._params.updateValue($1, forKey: $0) }
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

// MARK: - Input
extension ProfileSetupViewModel: ProfileSetupViewModelInput {
func setParams(_ params: [ProfilePageKey : Any]) {
        params.forEach { self._params.updateValue($1, forKey: $0) }
    }
}

// MARK: - Output
extension ProfileSetupViewModel: ProfileSetupViewModelOutput {
    var progress: AnyPublisher<Float, Never> {
        return currentPage
            .map { Float($0 + 1) / Float(self.totalPages) }
            .eraseToAnyPublisher()
    }
    
    var params: [ProfilePageKey : Any] {
        return _params
    }
}
