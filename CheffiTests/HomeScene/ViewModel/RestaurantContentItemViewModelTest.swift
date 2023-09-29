//
//  PopularRestaurantViewModelTest.swift
//  CheffiTests
//
//  Created by RONICK on 2023/09/29.
//

import XCTest
import Combine
@testable import Cheffi

final class RestaurantContentItemViewModelTest: XCTestCase {
    
    private var sut: RestaurantContentItemViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    private var input: RestaurantContentItemViewModel.Input!
    private var output: RestaurantContentItemViewModel.Output!
    
    private var initialize: PassthroughSubject<Void, Never>!
    
    private var contents: [Content] = [
        Content(
            id: UUID().uuidString,
            title: "그시절낭만의 근본 경양식 돈가스(1)",
            subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...",
            contentTimeLockSeconds: 303000 // 5분 3초
        ),
        Content(
            id: UUID().uuidString,
            title: "그시절낭만의 근본 경양식 돈가스(1)",
            subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...",
            contentTimeLockSeconds: 300000 // 5분
        ),
        Content(
            id: UUID().uuidString,
            title: "그시절낭만의 근본 경양식 돈가스(1)",
            subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...",
            contentTimeLockSeconds: 0 // 0
        ),
    ]
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        initialize = nil
        input = nil
        output = nil
        super.tearDown()
    }
    
    private func reset(contentIndex: Int) {
        sut = RestaurantContentItemViewModel(content: contents[contentIndex])
        initialize = PassthroughSubject<Void, Never>()
        input = RestaurantContentItemViewModel.Input(initialize: initialize.eraseToAnyPublisher())
        output = sut.transform(input: input)
    }
    
    
    func test_contentUnlock() {
        let expectation_unlock = XCTestExpectation(description: "unlock")
        
        reset(contentIndex: 0)
        
        output.timeLockType
            .sink {
                switch $0 {
                case .unlock(let digits):
                    XCTAssertEqual(digits, "00:05")
                    expectation_unlock.fulfill()
                default: XCTFail("unexpected fail")
                }
            }.store(in: &cancellables)
        
        initialize.send(())
        wait(for: [expectation_unlock], timeout: 1.0)
    }
    
    func test_contentWillLock() {
        let expectation_willLock = XCTestExpectation(description: "willLock")
        
        reset(contentIndex: 1)
        
        output.timeLockType
            .sink {
                switch $0 {
                case .willLock(let digits):
                    XCTAssertEqual(digits, "00:04:59")
                    expectation_willLock.fulfill()
                default: XCTFail("unexpected fail")
                }
            }.store(in: &cancellables)
        
        initialize.send(())
        wait(for: [expectation_willLock], timeout: 1.0)
    }
    
    func test_contentLock() {
        let expectation_lock = XCTestExpectation(description: "lock")
        
        reset(contentIndex: 2)
        
        output.timeLockType
            .sink {
                switch $0 {
                case .lock(let lockString):
                    XCTAssertEqual(lockString, "게시물 잠김")
                    expectation_lock.fulfill()
                default: XCTFail("unexpected fail")
                }
            }.store(in: &cancellables)
        
        initialize.send(())
        wait(for: [expectation_lock], timeout: 1.0)
    }
}
