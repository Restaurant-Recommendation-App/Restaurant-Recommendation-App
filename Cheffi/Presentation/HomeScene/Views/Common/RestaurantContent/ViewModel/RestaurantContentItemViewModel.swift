//
//  RestaurantContentItemViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/29.
//

import Foundation
import Combine

class RestaurantContentItemViewModel: Hashable, Identifiable {
    typealias Identifier = Int
    
    private let timeLockGenerator: TimeLockGenerator

    let id: Identifier
    let title: String
    let text: String
    var timeLockType: TimeLockType
    let photo: PhotoInfoDTO
    let locked: Bool
    let viewCount: Int
    let number: Int
    let reviewStatus: String
    let writtenByUser: Bool
    let bookmarked: Bool
    let purchased: Bool
    let active: Bool

    var cancellables = Set<AnyCancellable>()
    
    init(content: Content) {
        self.id = content.id
        self.title = content.title
        self.text = content.text
        self.photo = content.photo
        self.locked = content.locked
        self.viewCount = content.viewCount
        self.number = content.number
        self.reviewStatus = content.reviewStatus
        self.writtenByUser = content.writtenByUser
        self.bookmarked = content.bookmarked
        self.purchased = content.purchased
        self.active = content.active
        
        self.timeLockType = (content.timeLeftToLock <= 0)
        ? .lock(lockString: "게시물 잠금")
        : .unlock(
            digits: content.timeLeftToLock.getDayTimerStringByMilliseconds(timerDigitType: .hourMinute)
        )
        
        self.timeLockGenerator = TimeLockGenerator(
            timeLockSeconds: content.timeLeftToLock,
            countMilliseconds: 1000
        )
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RestaurantContentItemViewModel, rhs: RestaurantContentItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension RestaurantContentItemViewModel: ViewModelType {
    struct Input {
        var initialize: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var timeLockType: AnyPublisher<TimeLockType, Never>
    }
    
    func transform(input: Input) -> Output {
        
        cancellables.forEach {
            $0.cancel()
        }
        cancellables = Set<AnyCancellable>()
        
        let timeLockType = PassthroughSubject<TimeLockType, Never>()
            
        input.initialize
            .flatMap { self.timeLockGenerator.start(timerDigitType: .hourMinute) }
            .sink {
                timeLockType.send($0)
            }.store(in: &cancellables)
        
        return Output(timeLockType: timeLockType.eraseToAnyPublisher())
    }
}
