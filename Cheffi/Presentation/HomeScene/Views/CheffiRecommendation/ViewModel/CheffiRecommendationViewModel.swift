//
//  CheffiRecommendationViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/01.
//

import Combine
import Foundation

final class CheffiRecommendationViewModel: ViewModelType {
    
    struct Input {
        let initialize: PassthroughSubject<Void, Never>
        let scrolledToBottom: AnyPublisher<CGFloat, Never>
        let tappedCategory: AnyPublisher<Int, Never>
        let scrolledCategory: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let categories: AnyPublisher<[String], Never>
        let restaurantContentsViewModels: AnyPublisher<([[RestaurantContentsViewModel]], Int?, [CGFloat]?), Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    var initialized = false
    
    // 페이지네이션
    // TODO: 페이지네이션 로직 분리 필요
    var currentCategoryIndex = 0
    private var currentCategoriesPages = [Int]()
    private var contentsOffsetY = [CGFloat]()
    var isLoading = false
        
    private var maxContentHeight: CGFloat = 0
    
    private let cheffiRecommendationUseCase: CheffiRecommendationUseCase
            
    init(cheffiRecommendationUseCase: CheffiRecommendationUseCase) {
        self.cheffiRecommendationUseCase = cheffiRecommendationUseCase
    }
        
    func transform(input: Input) -> Output {
        cancellables.forEach {
            $0.cancel()
        }
        cancellables =  Set<AnyCancellable>()
        
        let restaurantContentsViewModels = PassthroughSubject<([[RestaurantContentsViewModel]], Int?, [CGFloat]?), Never>()
        
        let categories = PassthroughSubject<[String], Never>()
                        
        // TODO: Usecase 활용 필요
        input.initialize
            .filter { !self.initialized }
            .flatMap { self.cheffiRecommendationUseCase.getTags() }
            .sink { tags in
                restaurantContentsViewModels.send((popularRestaurantContentsViewModelMock, nil, nil))
                categories.send(tags)
                self.currentCategoriesPages = .init(repeating: 1, count: tags.count)
                self.contentsOffsetY = .init(repeating: 0, count: tags.count)
                self.initialized = true
            }.store(in: &cancellables)
                
        input.scrolledToBottom
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
            .filter { _ in !self.isLoading }
            .sink { contentOffsetY in
                self.isLoading = true
                self.contentsOffsetY[self.currentCategoryIndex] = contentOffsetY
                self.appendContents(index: self.currentCategoryIndex)
                restaurantContentsViewModels.send((
                    popularRestaurantContentsViewModelMock,
                    self.currentCategoryIndex,
                    self.contentsOffsetY
                ))
            }.store(in: &cancellables)

        //TODO: 중복 코드 제거
        input.tappedCategory
            .sink { categoryIndex in
                self.currentCategoryIndex = categoryIndex
            }.store(in: &cancellables)
        
        input.scrolledCategory
            .filter {  $0 != self.currentCategoryIndex }
            .sink { categoryIndex in
                self.currentCategoryIndex = categoryIndex
            }.store(in: &cancellables)

        return Output(
            categories: categories.eraseToAnyPublisher(),
            restaurantContentsViewModels: restaurantContentsViewModels.eraseToAnyPublisher()
        )
    }
    
    // 페이지네이션
    // TODO: 페이지네이션 로직 분리 필요
    private func appendContents(index: Int) {
        popularRestaurantContentsViewModelMock[index] += [
            RestaurantContentsViewModel(
                title: "그시절낭만의 근본 경양식 돈가스1", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
            ),
            RestaurantContentsViewModel(
                title: "그시절낭만의 근본 경양식 돈가스2", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
            ),
            RestaurantContentsViewModel(
                title: "그시절낭만의 근본 경양식 돈가스3", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
            ),
            RestaurantContentsViewModel(
                title: "그시절낭만의 근본 경양식 돈가스4", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
            ),
            RestaurantContentsViewModel(
                title: "그시절낭만의 근본 경양식 돈가스5", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
            ),
            RestaurantContentsViewModel(
                title: "그시절낭만의 근본 경양식 돈가스6", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
            ),
            RestaurantContentsViewModel(
                title: "그시절낭만의 근본 경양식 돈가스7", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
            ),
            RestaurantContentsViewModel(
                title: "그시절낭만의 근본 경양식 돈가스8", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
            ),
            RestaurantContentsViewModel(
                title: "그시절낭만의 근본 경양식 돈가스9", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
            ),
            RestaurantContentsViewModel(
                title: "그시절낭만의 근본 경양식 돈가스10", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
            )
        ]
    }
}

// TODO: 제거
let categoriesMock = ["한식", "양식", "중식", "일식", "퓨전", "샐러드"]

// TODO: 제거
var popularRestaurantContentsViewModelMock = [
    [
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스1", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스2", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스3", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스4", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        )
    ],
    [
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스1", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스2", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스3", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스4", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        )
    ],
    [
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스1", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스2", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스3", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스4", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        )
    ],
    [
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스1", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스2", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스3", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스4", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        )
    ],
    [
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스1", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스2", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스3", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스4", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        )
    ],
    [
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스1", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스2", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스3", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        ),
        RestaurantContentsViewModel(
            title: "그시절낭만의 근본 경양식 돈가스4", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
        )
    ]
]
