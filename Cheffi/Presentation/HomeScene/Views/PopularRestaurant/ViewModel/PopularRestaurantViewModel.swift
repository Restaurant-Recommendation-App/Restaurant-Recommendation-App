//
//  PopularRestaurantViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/01.
//

import Foundation
import Combine

final class PopularRestaurantViewModel: ViewModelType {
    private enum Constants {
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
            .flatMap { _ -> AnyPublisher<[Content], DataTransferError> in
                let reviewsByAreaRequest = ReviewsByAreaRequest(province: "서울특별시",
                                                                city: "강남구",
                                                                cursor: 0,
                                                                size: 16)
                return self.cheffiRecommendationUseCase.getContentsByArea(reviewsByAreaRequest: reviewsByAreaRequest)
            }
            .map { $0.map(RestaurantContentItemViewModel.init)}
            .sink(receiveCompletion: { completion in
                switch completion {
                    // TODO: 에러 처리
                case .failure(_):
                    break
                case .finished:
                    break
                }
            }, receiveValue: {
                var contentsItems = [[RestaurantContentItemViewModel]]([[RestaurantContentItemViewModel]($0[0...2])])
                let rest = $0[3..<$0.count].group(by: 4)!
                contentsItems += rest
                
                let viewModels = contentsItems.map {
                    PopularRestaurantContentsItemViewModel(items: $0)
                }
                
                contentsViewModel.send(viewModels)
                self.initialized = true
            }).store(in: &cancellables)
        
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
