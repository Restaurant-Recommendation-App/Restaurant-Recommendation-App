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

    private var cancellables = Set<AnyCancellable>()
    
    func testCategorySelection() {
        let viewModel = SimilarChefViewModel()
        
        let expectation = XCTestExpectation(description: "선택한 카테고리에 대한 태그 정보가 로드된다.")
        
        viewModel.profiles
            .sink { profiles in
                XCTAssertEqual(profiles, ["김맛집1", "김맛집2", "김맛집3", "김맛집4", "김맛집5", "김맛집6"])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.selectedCategory.send("")
        
        wait(for: [expectation], timeout: 1.0)
    }

}
