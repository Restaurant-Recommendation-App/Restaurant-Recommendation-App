//
//  SearchReviewResponse.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

struct SearchReviewResponse: Codable {
    let review: ReviewInfoDTO
    let restaurant: RestaurantDTO
    let reviewPhotos: [ReviewPhotoInfoDTO]
    let ratings: [RatingInfoDTO]
    
    enum CodingKeys: String, CodingKey {
        case review, restaurant, ratings
        case reviewPhotos = "review_photos"
    }
}
