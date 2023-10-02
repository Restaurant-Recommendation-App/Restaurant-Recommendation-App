//
//  RestaurantContentItemViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/29.
//

import Foundation
import Combine

class RestaurantContentItemViewModel: Hashable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let title: String
    let subtitle: String
    var timeLockType: TimeLockType
    
    private let timeLockGenerator: TimeLockGenerator
    
    var cancellables = Set<AnyCancellable>()
    
    init(content: Content) {
        self.id = content.id
        self.title = content.title
        self.subtitle = content.subtitle
        self.timeLockType = (content.contentTimeLockSeconds <= 0)
        ? .lock(lockString: "게시물 잠금")
        : .unlock(
            digits: content.contentTimeLockSeconds.getDayTimerStringByMilliseconds(timerDigitType: .hourMinute)
        )
        
        self.timeLockGenerator = TimeLockGenerator(
            timeLockSeconds: content.contentTimeLockSeconds,
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
