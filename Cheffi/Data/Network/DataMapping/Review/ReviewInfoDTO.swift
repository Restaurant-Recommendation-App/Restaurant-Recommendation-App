//
//  ReviewInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/19/23.
//

import Foundation

struct ReviewInfoDTO: Codable, Hashable {
    let id: Int // 리뷰 ID
    let title: String // 리뷰 제목
    let text: String // 리뷰의 적힌 본문 내용
    let ratingCount: Int? // 리뷰의 평가 총합 점수
    let bookmarked: Bool // 북마크 여부
    let ratedByUser: Bool? // 본인 평가 여부
    let ratingType: RatingType? // 본인 평가 타입
    let createdDate: String? // 생성일자
    let timeLeftToLock: Int? // 잠금까지 남은 시간 (ms 단위)
    let matchedTagNnumber: Int? // 태그 일치 개수
    let restaurant: RestaurantDTO? // 리뷰의 맛집 정보
    let writer: ReviewWriterInfoDTO? // 리뷰 작성자 정보
    let ratings: [String: Int]? // 리뷰의 평가 정보
    let photos: [ReviewPhotoInfoDTO]? // 리뷰의 사진 정보
    let menus: [MenuDTO]? // 리뷰의 메뉴 정보
    
    enum CodingKeys: String, CodingKey {
        case id, title, text, bookmarked, restaurant, writer, ratings, photos, menus
        case ratedByUser = "rated_by_user"
        case ratingType = "rating_type"
        case createdDate = "created_date"
        case timeLeftToLock = "time_left_to_lock"
        case matchedTagNnumber = "matched_tag_num"
        case ratingCount = "rating_cnt"
    }
    
}
