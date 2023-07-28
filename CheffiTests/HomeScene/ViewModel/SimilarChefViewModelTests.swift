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
        let testCategory = "test"
        let testUsers: [User] = (1...12).map({ User(id: "\($0)", name: "김맛집\($0)")})
        useCase.result = .success(testUsers)
        let expectation = XCTestExpectation(description: "")
        
        viewModel.combinedData
            .sink(receiveCompletion: { _ in },
                  receiveValue: { categories, users in
                      XCTAssertTrue(testUsers[0].id == users[0].id)
                      XCTAssertTrue(testUsers[0].name == users[0].name)
                      expectation.fulfill()
                  })
            .store(in: &cancellables)

        
        viewModel.selectedCategories.send([testCategory])
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockFetchSimilarChefUseCase: FetchSimilarChefUseCase {
    var result: Result<[User], Error>!

    func execute(categories: [String]) -> AnyPublisher<[User], Error> {
        return Future { promise in
            promise(self.result)
        }
        .eraseToAnyPublisher()
    }
}

class MockSimilarChefRepository: SimilarChefRepository {
    func getCategories() -> AnyPublisher<[String], Error> {
        let exampleCategories = ["한식", "노포", "아시아음식", "매운맛", "친절함"]
        return Just(exampleCategories)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getProfiles(categories: [String]) -> AnyPublisher<[Cheffi.User], Error> {
        let exampleProfiles = (1...12).map({ User(id: "\($0)", name: "김맛집\($0)")})
        
        return Just(exampleProfiles)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

