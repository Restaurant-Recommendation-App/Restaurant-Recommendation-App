//
//  TimeLockGenerator.swift
//  Cheffi
//
//  Created by RONICK on 2023/09/25.
//

import Foundation
import Combine

enum TimerDigitType {
    case hour
    case hourMinute
    case hourMinuteSecond
}

enum TimeLockType {
    case lock(lockString: String)
    case unlock(digits: String)
    case willLock(digits: String)
}

final class TimeLockGenerator {
    
    enum Constants {
        static let willLockMilliseconds = 300000
    }
    
    var timerStarted = false
    var timeLockMilliseconds: Int
    let countMilliseconds: Int
    
    init(timeLockSeconds: Int, countMilliseconds: Int) {
        self.timeLockMilliseconds = timeLockSeconds
        self.countMilliseconds = countMilliseconds
    }
    
    func generateTimeLock(timerDigitType: TimerDigitType) -> AnyPublisher<TimeLockType, Never> {
        timerStarted = true
        return Timer.publish(every: 1, on: RunLoop.main, in: .common).autoconnect()
            .map { _ in self.timerCall(timerDigitType: timerDigitType) }
            .eraseToAnyPublisher()
    }
    
    private func timerCall(timerDigitType: TimerDigitType) -> TimeLockType {
        timeLockMilliseconds -= countMilliseconds
        
        let timeLockType: TimeLockType
        if timeLockMilliseconds < 0 {
            timeLockType = TimeLockType.lock(lockString: "게시물 잠김")
            timeLockMilliseconds = 0
        } else if timeLockMilliseconds < Constants.willLockMilliseconds {
            timeLockType = TimeLockType.willLock(
                digits: timeLockMilliseconds.getDayTimerStringByMilliseconds(timerDigitType: .hourMinuteSecond)
            )
        } else {
            timeLockType = TimeLockType.unlock(
                digits: timeLockMilliseconds.getDayTimerStringByMilliseconds(timerDigitType: timerDigitType)
            )
        }
            
        return timeLockType
    }
}
