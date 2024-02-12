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
    private let paginationGenerator =  DefaultPaginationGenerator<Content>(cursor: 0, size: 10)
    
    private var initialized = false
    private let tagId: Int?
    
    @Published private var scrollOffsetY: CGFloat = 0
    
    var items = [RestaurantContentItemViewModel]()
            
    init(tagId: Int?, cheffiRecommendationUseCase: CheffiRecommendationUseCase) {
        self.tagId = tagId
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
            .filter { self.initialized }
            .sink { _ in
                contentItems.send(self.items)
                scrollOffsetY.send(self.scrollOffsetY)
            }.store(in: &cancellables)
        
        initialize
            .filter { !self.initialized }
            .flatMap { self.fetchContents() }
            .sink(receiveCompletion: { completion in
                switch completion {
                // TODO: 에러 처리
                case .failure(_):
                    break
                case .finished:
                    break
                }
            }, receiveValue: { contents in
                self.items = contents
                contentItems.send(self.items)
                self.initialized = true
            }).store(in: &cancellables)
        
        input.verticallyScrolled
            .assign(to: &self.$scrollOffsetY)
        
        input.scrolledToBottom
            .filter { self.paginationGenerator.fetchStatus == .ready }
            .flatMap { self.fetchContents() }
            .sink(receiveCompletion: { completion in
                switch completion {
                // TODO: 에러 처리
                case .failure(_):
                    break
                case .finished:
                    break
                }
            }, receiveValue: { contents in
                self.items += contents
                contentItems.send(self.items)
            }).store(in: &cancellables)
        
        return Output(
            contentItems: contentItems.eraseToAnyPublisher(),
            scrolleOffsetY: scrollOffsetY.eraseToAnyPublisher()
        )
    }
    
    // TODO: 에러 처리
    private func fetchContents() -> AnyPublisher<[RestaurantContentItemViewModel], DataTransferError> {
        let result = CurrentValueSubject<[Content], DataTransferError>([Content]())
        
        paginationGenerator.next(
            fetch: { cursor, size, onCompletion, onError in
                let contents: AnyPublisher<[Content], DataTransferError>
                
                if let tagId = tagId {
                    let reviewsByTagRequest = ReviewsByTagRequest(province: "서울특별시",
                                                                  city: "강남구",
                                                                  cursor: cursor,
                                                                  size: size,
                                                                  tagId: tagId)
                    contents = self.cheffiRecommendationUseCase.getContentsByTag(reviewsByTagRequest: reviewsByTagRequest)
                } else {
                    let reviewsByAreaRequest = ReviewsByAreaRequest(province: "서울특별시",
                                                                    city: "강남구",
                                                                    cursor: cursor,
                                                                    size: size)
                    contents = self.cheffiRecommendationUseCase.getContentsByArea(reviewsByAreaRequest: reviewsByAreaRequest)
                }
                
                contents
                    .sink(receiveCompletion: { completion in
                        switch completion {
                            // TODO: 에러 처리
                        case .failure(let error):
                            onError(error)
                        case .finished:
                            break
                        }
                    }, receiveValue: { contents in
                        onCompletion(contents)
                    }).store(in: &self.cancellables)
            }, onCompletion: {
                result.send($0)
            }, onError: {
                if let dataTransferError = $0 as? DataTransferError {
                    result.send(completion: .failure(dataTransferError))
                }
            }
        )
        
        return result
            .map { $0.map(RestaurantContentItemViewModel.init) }
            .eraseToAnyPublisher()
    }
}
