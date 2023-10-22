//
//  SimilarChefViewModelTests.swift
//  CheffiTests
//
//  Created by USER on 2023/07/15.
//

import XCTest
import Combine
@testable import Cheffi

final class SimilarChefViewModelTests: XCTestCase {
    
    private var viewModel: SimilarChefViewModel!
    private var useCase: MockSimilarChefUseCase!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        
        useCase = MockSimilarChefUseCase()
        viewModel = SimilarChefViewModel(useCase: useCase)
        cancellables = []
    }
}

class MockSimilarChefUseCase: SimilarChefUseCase {
    var tags: Result<([Cheffi.Tag], HTTPURLResponse), Cheffi.DataTransferError>!
    var users: Result<[Cheffi.User], Cheffi.DataTransferError>!
    
    func getTags(type: Cheffi.TagType) -> AnyPublisher<([Cheffi.Tag], HTTPURLResponse), Cheffi.DataTransferError> {
        return Future { promise in
            promise(self.tags)
        }
        .eraseToAnyPublisher()
    }
    
    func getUsers(tags: [String]) -> AnyPublisher<[Cheffi.User], Cheffi.DataTransferError> {
        return Future { promise in
            promise(self.users)
        }
        .eraseToAnyPublisher()
    }
}

