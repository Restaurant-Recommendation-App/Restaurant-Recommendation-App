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
    let steps: PassthroughSubject<RouteStep, Never>
    
    init(
        steps: PassthroughSubject<RouteStep, Never>
    ) {
        self.steps = steps
    }
    
    struct State: Equatable {
        let navigationBarState = NavigationBarReducer.State(
            title: "마이페이지",
            leftButtonKind: .back,
            rightButtonKind: .setting
        )
        var myReviewThumbnailListState = ReviewThumbnailListReducer.State()
        var purchasedReviewThumbnailListState = ReviewThumbnailListReducer.State()
        var bookmarkedReviewThumbnailListState = ReviewThumbnailListReducer.State()
        
        var allTags: [Tag] = [
            // TODO: API 연동
            Tag(id: 0, type: .food, name: "매콤한"),
            Tag(id: 1, type: .food, name: "노포"),
            Tag(id: 2, type: .food, name: "웨이팅 짧은"),
            Tag(id: 3, type: .food, name: "아시아음식"),
            Tag(id: 4, type: .food, name: "한식"),
            Tag(id: 5, type: .food, name: "비건"),
            Tag(id: 6, type: .food, name: "분위기 있는 곳")
        ]
    }
    
    enum Action {
        case onAppear
        case navigationBarAction(NavigationBarReducer.Action)
        case myReviewThumbnailListAction(ReviewThumbnailListReducer.Action)
        case purchasedReviewThumbnailListAction(ReviewThumbnailListReducer.Action)
        case bookmarkedReviewThumbnailListAction(ReviewThumbnailListReducer.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
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
            return .none
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
        }
    }
}

extension MyPageReducer: Stepper {}
