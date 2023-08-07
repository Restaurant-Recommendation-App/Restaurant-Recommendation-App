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
    private var useCase: MockFetchSimilarChefUseCase!
    private var repository: MockSimilarChefRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        
        useCase = MockFetchSimilarChefUseCase()
        repository = MockSimilarChefRepository()
        viewModel = SimilarChefViewModel(fetchSimilarChefUseCase: useCase, repository: repository)
        cancellables = []
    }

    func testSelectedCategoryFetchesProfiles() {
        let testTag = "test"
        let testUsers: [User] = (1...12).map({ User(id: $0, name: "김맛집\($0)")})
        useCase.result = .success(testUsers)
        let expectation = XCTestExpectation(description: "")
        
        viewModel.combinedData
            .sink(receiveCompletion: { _ in },
                  receiveValue: { tags, users in
                      XCTAssertTrue(testUsers[0].id == users[0].id)
                      XCTAssertTrue(testUsers[0].name == users[0].name)
                      expectation.fulfill()
                  })
            .store(in: &cancellables)

        
        viewModel.selectTags([testTag])
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockFetchSimilarChefUseCase: FetchSimilarChefUseCase {
    var result: Result<[User], Cheffi.DataTransferError>!

    func execute(tags: [String]) -> AnyPublisher<[Cheffi.User], Cheffi.DataTransferError> {
        return Future { promise in
            promise(self.result)
        }
        .eraseToAnyPublisher()
    }
}

class MockSimilarChefRepository: SimilarChefRepository {
    func getCheffiTags() -> AnyPublisher<[Cheffi.CheffiTagResponseDTO], Cheffi.DataTransferError> {
        let exampleTags = ["한식", "노포", "아시아음식", "매운맛", "친절함"]
        let exampleTagDTOs = exampleTags.map({ Cheffi.CheffiTagResponseDTO(name: $0) })
        return Just(exampleTagDTOs)
            .setFailureType(to: Cheffi.DataTransferError.self)
            .eraseToAnyPublisher()
    }
    
    func getProfiles(tags: [String]) -> AnyPublisher<[Cheffi.UserResponseDTO], Cheffi.DataTransferError> {
        let exampleProfiles = (1...12).map({ User(id: $0, name: "김맛집\($0)")})
        let exampleProfileDTOs = exampleProfiles.map({ Cheffi.UserResponseDTO(id: $0.id, name: $0.name) })
        return Just(exampleProfileDTOs)
            .setFailureType(to: Cheffi.DataTransferError.self)
            .eraseToAnyPublisher()
    }
}

