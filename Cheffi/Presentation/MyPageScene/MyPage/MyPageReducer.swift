//
//  MyPageReducer.swift
//  Cheffi
//
//  Created by 김문옥 on 4/5/24.
//

import Foundation
import Combine
import ComposableArchitecture

struct MyPageReducer: Reducer {
    private let useCase: ProfileUseCase
    let steps: PassthroughSubject<RouteStep, Never>
    /// 유저 프로필 요청시 필요한 ID. `nil` 이면 자기 자신의 프로필페이지를 뜻함.
    private let userId: Int?
    
    init(
        useCase: ProfileUseCase,
        steps: PassthroughSubject<RouteStep, Never>,
        userId: Int?
    ) {
        self.useCase = useCase
        self.steps = steps
        self.userId = userId
    }
    
    struct State: Equatable {
        let navigationBarState = NavigationBarReducer.State(
            title: "마이페이지",
            leftButtonKind: nil,
            rightButtonKind: .setting
        )
        var myReviewThumbnailListState = ReviewThumbnailListReducer.State()
        var purchasedReviewThumbnailListState = ReviewThumbnailListReducer.State()
        var bookmarkedReviewThumbnailListState = ReviewThumbnailListReducer.State()
        var isEmptyMyReviewThumbnailList: Bool = false
        var isEmptyPurchasedReviewThumbnailList: Bool = false
        var isEmptyBookmarkedReviewThumbnailList: Bool = false
        let myReviewEmptyState = EmptyDescriptionViewReducer.State(
            imageName: "empty_restaurant",
            descriptionText: "나만의 맛집을 소개하고\n다른 쉐피들과 맛을 탐구해보세요",
            emptyViewButtonState: EmptyViewButtonReducer.State(title: "맛집 직접 등록하기")
        )
        
        var profile: Profile?
    }
    
    enum Action {
        case onAppear
        case navigationBarAction(NavigationBarReducer.Action)
        case myReviewThumbnailListAction(ReviewThumbnailListReducer.Action)
        case purchasedReviewThumbnailListAction(ReviewThumbnailListReducer.Action)
        case bookmarkedReviewThumbnailListAction(ReviewThumbnailListReducer.Action)
        case restaurantEmptyAction(EmptyDescriptionViewReducer.Action)
        
        case getProfile(Int?)
        case successGetProfile(Profile)
        case occurError(Error)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isEmptyMyReviewThumbnailList = true
            state.myReviewThumbnailListState = .init(reviews: [
                // TODO: API 연동
                ReviewInfoDTO(
                    id: 1,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: true
                ),
                ReviewInfoDTO(
                    id: 2,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: false,
                    writenByUser: true
                ),
                ReviewInfoDTO(
                    id: 3,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: true
                ),
                ReviewInfoDTO(
                    id: 4,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: true
                ),
                ReviewInfoDTO(
                    id: 5,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: false,
                    writenByUser: true
                )
            ])
            state.isEmptyPurchasedReviewThumbnailList = true
            state.purchasedReviewThumbnailListState = .init(reviews: [
                // TODO: API 연동
                ReviewInfoDTO(
                    id: 1,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: true
                ),
                ReviewInfoDTO(
                    id: 2,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: true
                ),
                ReviewInfoDTO(
                    id: 3,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: false
                ),
                ReviewInfoDTO(
                    id: 4,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: true
                ),
                ReviewInfoDTO(
                    id: 5,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: false
                ),
                ReviewInfoDTO(
                    id: 6,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: true
                ),
                ReviewInfoDTO(
                    id: 7,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: false
                )
            ])
            state.isEmptyBookmarkedReviewThumbnailList = true
            state.bookmarkedReviewThumbnailListState = .init(reviews: [
                // TODO: API 연동
                ReviewInfoDTO(
                    id: 1,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: true
                ),
                ReviewInfoDTO(
                    id: 2,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: true,
                    writenByUser: false
                ),
                ReviewInfoDTO(
                    id: 3,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: false,
                    writenByUser: true
                ),
                ReviewInfoDTO(
                    id: 4,
                    title: "태초동에 생긴 맛집!!",
                    text: "초밥 태초세트 추천해요",
                    bookmarked: true,
                    ratedByUser: true,
                    ratingType: .average,
                    createdDate: nil,
                    timeLeftToLock: 86399751,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: nil,
                    purchased: false,
                    writenByUser: false
                )
            ])
            return .send(.getProfile(userId))
        case .navigationBarAction(let action):
            switch action {
            case .rightButtonTapped:
                // TODO: 프로필 수정 화면 띄우기
//                steps.send(.presentSetting)
                return .none
            default: return .none
            }
        case .myReviewThumbnailListAction(let action),
                .purchasedReviewThumbnailListAction(let action),
                .bookmarkedReviewThumbnailListAction(let action):
            switch action {
            case .tap(let review):
                // TODO: 리뷰상세로 이동
    //            steps.send(.pushReviewDetail)
                return .none
            }
        case .restaurantEmptyAction(let action):
            switch action {
            case .emptyViewButtonAction(let action):
                switch action {
                case .tapButton:
                    steps.send(.pushRestaurantRegistCompose)
                    return .none
                }
            }
        case .getProfile(let id):
            return .publisher {
                useCase.getProfile(id: id)
                    .receive(on: UIScheduler.shared)
                    .map(Action.successGetProfile)
                    .catch { Just(.occurError($0)) }
            }
        case .successGetProfile(let profile):
            state.profile = profile
            return .none
        case .occurError(let error):
            // TODO: Eli - 에러 핸들링
//            state.error = error.localizedDescription
            return .none
        }
    }
}

extension MyPageReducer: Stepper {}
