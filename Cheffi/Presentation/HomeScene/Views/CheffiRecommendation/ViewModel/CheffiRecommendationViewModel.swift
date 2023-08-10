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
        let reloadedContents: AnyPublisher<Void, Never>
        let viewMoreButtonTapped: AnyPublisher<Void, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let tappedCategory: AnyPublisher<Int, Never>
        let scrolledCategory: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let categories: AnyPublisher<[String], Never>
        let restaurantContentsViewModels: AnyPublisher<([[RestaurantContentsViewModel]], Bool), Never>
        let hideMoreViewButton: AnyPublisher<Void, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    var initialized = false
    
    // 페이지네이션
    // TODO: 페이지네이션 로직 분리 필요
    var currentCategoryIndex = 0
    private var currentCategoriesPages = [Int]()
    private var maxCategoryPage = 1
    private var isLoading = false
    
    private var moreViewButtonTapped = false
    
    func transform(input: Input) -> Output {
        cancellables.forEach {
            $0.cancel()
        }
        cancellables =  Set<AnyCancellable>()
        
        let restaurantContentsViewModels = PassthroughSubject<([[RestaurantContentsViewModel]], Bool), Never>()
        
        let categories = PassthroughSubject<[String], Never>()
        
        let hideMoreViewButton = PassthroughSubject<Void, Never>()

        // TODO: Usecase 활용 필요
        input.initialize
            .filter { !self.initialized }
            .sink { _ in                restaurantContentsViewModels.send((popularRestaurantContentsViewModelMock, false))
                categories.send(categoriesMock)
                self.currentCategoriesPages = .init(repeating: 1, count: categoriesMock.count)
                self.initialized = true
            }.store(in: &cancellables)
        
        input.reloadedContents
            .sink { _ in
                self.isLoading = false
                restaurantContentsViewModels.send((popularRestaurantContentsViewModelMock, false))
            }.store(in: &cancellables)
        
        input.viewMoreButtonTapped
            .sink { _ in
                self.moreViewButtonTapped = true
                self.maxCategoryPage += 1
                self.appendContents(index: self.currentCategoryIndex)
                hideMoreViewButton.send(())
                restaurantContentsViewModels.send((popularRestaurantContentsViewModelMock, true))
            }.store(in: &cancellables)
        
        input.scrolledToBottom
            .filter { self.moreViewButtonTapped && !self.isLoading }
            .sink { _ in
                self.isLoading = true
                self.maxCategoryPage += 1
                self.appendContents(index: self.currentCategoryIndex)
                restaurantContentsViewModels.send((popularRestaurantContentsViewModelMock, true))
            }.store(in: &cancellables)

        //TODO: 중복 코드 제거
        input.tappedCategory
            .sink { categoryIndex in
                self.currentCategoryIndex = categoryIndex
                guard self.currentCategoriesPages[categoryIndex] < self.maxCategoryPage
                else { return }
                
                self.appendContents(index: categoryIndex)
                restaurantContentsViewModels.send((popularRestaurantContentsViewModelMock, true))
            }.store(in: &cancellables)
        
        input.scrolledCategory
            .filter { self.moreViewButtonTapped && $0 != self.currentCategoryIndex }
            .sink { categoryIndex in
                self.currentCategoryIndex = categoryIndex
                guard self.currentCategoriesPages[categoryIndex] < self.maxCategoryPage
                else { return }

                self.appendContents(index: categoryIndex)
                restaurantContentsViewModels.send((popularRestaurantContentsViewModelMock, true))
            }.store(in: &cancellables)

        return Output(
            categories: categories.eraseToAnyPublisher(),
            restaurantContentsViewModels: restaurantContentsViewModels.eraseToAnyPublisher(),
            hideMoreViewButton: hideMoreViewButton.eraseToAnyPublisher()
        )
    }
    
    private func appendContents(index: Int) {
        for _ in self.currentCategoriesPages[index] ..< self.maxCategoryPage {
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
                    title: "그시절낭만의 근본 경양식 돈가스4", subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...", contentImageHeight: 165
                )
            ]
        }
        self.currentCategoriesPages[index] = maxCategoryPage
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
