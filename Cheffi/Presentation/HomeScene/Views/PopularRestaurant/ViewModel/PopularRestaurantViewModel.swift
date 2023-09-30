//
//  PopularRestaurantViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/01.
//

import Foundation
import Combine

final class PopularRestaurantViewModel: ViewModelType {
    
    enum Constants {
        static let dayMilliseconds = 86400000
    }
    
    struct Input {
        let initialize: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let contentsViewModel: AnyPublisher<[PopularRestaurantContentsItemViewModel], Never>
        let timeLockType: AnyPublisher<String, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    private let cheffiRecommendationUseCase: CheffiRecommendationUseCase
    private let timeLockGenerator: TimeLockGenerator
    
    private var initialized = false
    private var timerStarted = false
    
    init(cheffiRecommendationUseCase: CheffiRecommendationUseCase) {
        self.cheffiRecommendationUseCase = cheffiRecommendationUseCase
        self.timeLockGenerator = TimeLockGenerator(
            timeLockSeconds: Constants.dayMilliseconds,
            countMilliseconds: 1000
        )
    }
    
    func transform(input: Input) -> Output {
        let contentsViewModel = PassthroughSubject<[PopularRestaurantContentsItemViewModel], Never>()
        let initialize = input.initialize.share()
        
        initialize
            .filter { !self.initialized }
            .flatMap { self.cheffiRecommendationUseCase.getContents(with: "popularity", page: 1) }
            .map { $0.map(RestaurantContentItemViewModel.init)}
            .sink {
                var contentsItems = [[RestaurantContentItemViewModel]]([[RestaurantContentItemViewModel]($0[0...2])])
                let rest = $0[3..<$0.count].group(by: 4)!
                contentsItems += rest
                
                let viewModels = contentsItems.map {
                    PopularRestaurantContentsItemViewModel(items: $0)
                }
                
                contentsViewModel.send(viewModels)
                self.initialized = true
        }.store(in: &cancellables)
        
        let timerString = PassthroughSubject<String, Never>()
        
        initialize
            .flatMap { self.timeLockGenerator.start(timerDigitType: .hourMinuteSecond) }
            .sink {
                let timeLockString: String
                switch $0 {
                case .lock(let lockString):
                    timeLockString = lockString
                case .unlock(let digits):
                    timeLockString = digits
                case .willLock(let digits):
                    timeLockString = digits
                }
                timerString.send(timeLockString)
            }.store(in: &cancellables)

        return Output(
            contentsViewModel: contentsViewModel.eraseToAnyPublisher(),
            timeLockType: timerString.eraseToAnyPublisher()
        )
    }
}
