//
//  ReviewThumbnailItem.swift
//  Cheffi
//
//  Created by 김문옥 on 4/20/24.
//

import SwiftUI

struct ReviewThumbnailItem: View {
    let review: ReviewInfoDTO
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // TODO: review.photo
            Image("empty_menu_background")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            // TODO: 제거
                .background(.blue)
            
            if review.isLock {
                HStack(spacing: 0) {
                    HStack(spacing: 8.0) {
                        Image(.lockClosedOutline)
                        
                        Text(review.timeLeftToLock?.getDayTimerStringByMilliseconds(timerDigitType: .hourMinute) ?? "")
                            .font(.custom("SUIT", size: 14).weight(.semibold))
                            .foregroundColor(.cheffiWhite)
                    }
                    .frame(height: 32.0)
                    .padding(.horizontal, 12.0)
                    .background(Color(white: 0, opacity: 0.32))
                    .cornerRadius(16.0)
                }
                .padding(8.0)
            }
        }
        .cornerRadius(10.0)
        .padding(.bottom, 16.0)
    }
}

#Preview {
    ReviewThumbnailItem(review: ReviewInfoDTO(
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
        purchased: false,
        writenByUser: false
    ))
}
