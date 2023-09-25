//
//  Int+Extensions.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/29.
//

import Foundation

extension Int {

    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    internal var commaRepresentation: String {
        return Int.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    func getDayTimerStringByMilliseconds(timerDigitType: TimerDigitType) -> String {
        let hours = self / 3600000
        let minutes = (self % 3600000) / 60000
        let seconds = (self % 3600000) % 60000 / 1000
        //MARK: milliseconds 처리 코드 추가 위치
        
        let hourString = (hours >= 10) ? "\(hours)" : "0\(hours)"
        let minuteString = (minutes >= 10) ? "\(minutes)" : "0\(minutes)"
        let secondsString = (seconds >= 10) ? "\(seconds)" : "0\(seconds)"
        
        switch timerDigitType {
        case .hour: return "\(hourString)"
        case .hourMinute: return "\(hourString):\(minuteString)"
        case .hourMinuteSecond: return "\(hourString):\(minuteString):\(secondsString)"
        }
    }
}

