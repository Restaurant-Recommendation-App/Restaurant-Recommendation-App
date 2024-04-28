//
//  ReviewThumbnailListView.swift
//  Cheffi
//
//  Created by 김문옥 on 4/20/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(ReviewThumbnailListReducer.self)
struct ReviewThumbnailListView: View {
    var body: some View {
        VStack(spacing: 0) {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 13.0), count: 2),
                spacing: 0
            ) {
                ForEach(viewStore.reviews, id: \.self) { review in
                    ReviewThumbnailItem(review: review)
                        .gesture(
                            TapGesture()
                                .onEnded { _ in
                                    viewStore.send(.tap(review))
                                }
                        )
                }
            }
            .padding(.horizontal, 16.0)
            
            Spacer()
        }
    }
}

struct ReviewThumbnailListView_Preview: PreviewProvider {
    static var previews: some View {
        ReviewThumbnailListView(
            Store(initialState: ReviewThumbnailListReducer.State(
                reviews: [
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
                ]
            )) {
                ReviewThumbnailListReducer()._printChanges()
            }
        )
    }
}
