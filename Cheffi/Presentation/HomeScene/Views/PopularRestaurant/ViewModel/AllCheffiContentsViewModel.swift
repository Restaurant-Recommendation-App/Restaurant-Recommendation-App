//
//  AllCheffiContentsViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/09.
//


import Foundation
import Combine

struct AllCheffiContentsViewModelActions {
    let showAreaSelection: () -> Void
}

final class AllCheffiContentsViewModel: ViewModelType {
    
    private enum Constants {
        static let dayMilliseconds = 86400000
    }
    
    struct Input {
        let initialize: AnyPublisher<Void, Never>
        let titleButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let contentsViewModel: AnyPublisher<RestaurantContentsViewModel, Never>
        let timeLockType: AnyPublisher<String, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    private let cheffiRecommendationUseCase: CheffiRecommendationUseCase
    private let timeLockGenerator: TimeLockGenerator
    
    private let tag: String
    private let actions: AllCheffiContentsViewModelActions
    
    init(tag: String, actions: AllCheffiContentsViewModelActions , cheffiRecommendationUseCase: CheffiRecommendationUseCase) {
        self.tag = tag
        self.actions = actions
        self.cheffiRecommendationUseCase = cheffiRecommendationUseCase
        self.timeLockGenerator = TimeLockGenerator(
            timeLockSeconds: Constants.dayMilliseconds,
            countMilliseconds: 1000
        )
    }
    
    func transform(input: Input) -> Output {
        let contentsViewModel = PassthroughSubject<RestaurantContentsViewModel, Never>()
        let initialize = input.initialize.share()
        
        initialize
            .sink {
                let viewModel = RestaurantContentsViewModel(
                    tag: self.tag,
                    cheffiRecommendationUseCase: self.cheffiRecommendationUseCase
                )
                
                contentsViewModel.send(viewModel)
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
        
        input.titleButtonTapped
            .sink {
                self.actions.showAreaSelection()
            }.store(in: &cancellables)
        
        return Output(
            contentsViewModel: contentsViewModel.eraseToAnyPublisher(),
            timeLockType: timerString.eraseToAnyPublisher()
        )
    }
    
}

