//
//  ReviewInfo.swift
//  CheffiTests
//
//  Created by Juhyun Seo on 10/21/23.
//

import XCTest
@testable import Cheffi

final class ReviewInfoRelativeTimeTests: XCTestCase {
    var label: UILabel!
    
    override func setUp() {
        super.setUp()
        label = UILabel()
    }
    
    override func tearDown() {
        label = nil
        super.tearDown()
    }
    
    func testJustNow() {
        let secondsAgo = -59 // 59초 전
        let dateStr = createDateString(secondsAgo: secondsAgo)
        label.setRelativeTime(from: dateStr)
        XCTAssertEqual(label.text, "방금 전")
    }
    
    func testOneHourAgo() {
        let secondsAgo = -3601 // 1시간 1초 전
        let dateStr = createDateString(secondsAgo: secondsAgo)
        label.setRelativeTime(from: dateStr)
        XCTAssertEqual(label.text, "1시간 전")
    }
    
    func testMultipleHoursAgo() {
        let secondsAgo = -7200 // 정확히 2시간 전을 나타내는 초 단위 시간.
        let dateStr = createDateString(secondsAgo: secondsAgo)
        label.setRelativeTime(from: dateStr)
        XCTAssertEqual(label.text, "2시간 전")
    }
    
    func testOneDayAgo() {
        let secondsAgo = -86401 // 24시간 1초 전
        let dateStr = createDateString(secondsAgo: secondsAgo)
        label.setRelativeTime(from: dateStr)
        XCTAssertEqual(label.text, "1일 전")
    }
    
    func testMultipleDaysAgo() {
        let secondsAgo = -2591999 // 29일 23시간 59분 59초 전
        let dateStr = createDateString(secondsAgo: secondsAgo)
        label.setRelativeTime(from: dateStr)
        XCTAssertEqual(label.text, "29일 전")
    }
    
    func testOneMonthAgo() {
        let secondsAgo = -2592001 // 30일 1초 전
        let dateStr = createDateString(secondsAgo: secondsAgo)
        label.setRelativeTime(from: dateStr)
        XCTAssertEqual(label.text, "1달 전")
    }
    
    private func createDateString(secondsAgo: Int) -> String {
        let date = Date(timeIntervalSinceNow: TimeInterval(secondsAgo))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: date)
    }
}
