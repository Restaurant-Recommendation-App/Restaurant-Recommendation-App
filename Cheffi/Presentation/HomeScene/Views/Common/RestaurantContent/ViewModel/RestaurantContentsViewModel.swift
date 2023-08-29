//
//  RestaurantContentsViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/28.
//

import Foundation
import Combine

final class RestaurantContentsViewModel: ViewModelType {
    typealias ContentOffsetY = CGFloat
    
    struct Input {
        let initialize: AnyPublisher<Void, Never>
        let verticallyScrolled: AnyPublisher<ContentOffsetY, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let contentItems: AnyPublisher<[RestaurantContentItemViewModel], Never>
        let scrolleOffsetY: AnyPublisher<ContentOffsetY, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    private let cheffiRecommendationUseCase: CheffiRecommendationUseCase
    private let pagenationGenerator =  DefaultPagenationGenerator<Content>(page: 1)
    
    private var initialized = false
    private let tag: String
    
    @Published private var scrollOffsetY: CGFloat = 0
    
    private var items = [RestaurantContentItemViewModel]()
            
    init(tag: String, cheffiRecommendationUseCase: CheffiRecommendationUseCase) {
        self.tag = tag
        self.cheffiRecommendationUseCase = cheffiRecommendationUseCase
    }
    
    func transform(input: Input) -> Output {
        
        cancellables.forEach {
            $0.cancel()
        }
        cancellables = Set<AnyCancellable>()
        
        let contentItems = PassthroughSubject<[RestaurantContentItemViewModel], Never>()
        let scrollOffsetY = PassthroughSubject<ContentOffsetY, Never>()
        
        let initialize = input.initialize.share()
        
        initialize
            .filter { !self.initialized }
            .flatMap { self.fetchContents() }
            .sink { contents in
                self.items = contents
                contentItems.send(self.items)
                self.initialized = true
            }.store(in: &cancellables)
        
        initialize
            .filter { self.initialized }
            .sink { _ in
                contentItems.send(self.items)
                scrollOffsetY.send(self.scrollOffsetY)
            }.store(in: &cancellables)
        
        input.verticallyScrolled
            .assign(to: &self.$scrollOffsetY)
        
        input.scrolledToBottom
            .filter { self.pagenationGenerator.fetchStatus == .ready }
            .flatMap { self.fetchContents() }
            .sink { contents in
                self.items += contents
                contentItems.send(self.items)
            }.store(in: &cancellables)
        
        return Output(
            contentItems: contentItems.eraseToAnyPublisher(),
            scrolleOffsetY: scrollOffsetY.eraseToAnyPublisher()
        )
    }
    
    // TODO: 에러 처리
    func fetchContents() -> AnyPublisher<[RestaurantContentItemViewModel], Never> {
        let result = CurrentValueSubject<[Content], Never>([Content]())
        
        pagenationGenerator.next(
            fetch: { page, onCompletion, onError in
                self.cheffiRecommendationUseCase.getContents(with: self.tag, page: page)
                    .sink { onCompletion($0) }
                    .store(in: &self.cancellables)
            }, onCompletion: {
                result.send($0)
            }, onError: {_ in
//                result.send(completion: .failure($0))
            }
        )
        
        return result
            .map { $0.map(RestaurantContentItemViewModel.init) }
            .eraseToAnyPublisher()
    }
}
