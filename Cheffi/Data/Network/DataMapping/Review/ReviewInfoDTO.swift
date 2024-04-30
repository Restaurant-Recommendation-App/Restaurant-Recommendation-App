//
//  ReviewInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/19/23.
//

import Foundation

struct ReviewInfoDTO: Codable, Hashable {
    /// 리뷰 ID
    let id: Int
    /// 리뷰 제목
    let title: String
    /// 리뷰의 적힌 본문 내용
    let text: String
    /// 북마크 여부
    let bookmarked: Bool
    /// 본인 평가 여부
    let ratedByUser: Bool?
    /// 본인 평가 타입
    let ratingType: RatingType?
    /// 생성일자
    let createdDate: String?
    /// 잠금까지 남은 시간 (ms 단위)
    let timeLeftToLock: Int?
    /// 태그 일치 개수
    let matchedTagNum: Int?
    /// 리뷰의 맛집 정보
    let restaurant: RestaurantDTO?
    /// 리뷰 작성자 정보
    let writer: ReviewWriterInfoDTO?
    /// 리뷰의 평가 정보
    let ratings: [String: Int]?
    /// 리뷰의 사진 정보
    let photos: [PhotoInfoDTO]?
    /// 리뷰의 메뉴 정보
    let menus: [MenuDTO]?
    /// 구매한 리뷰인지 여부
    let purchased: Bool?
    /// 유저에 의해 작성된 리뷰인지 여부
    let writenByUser: Bool?
    
    /// 리뷰 조회 잠금 여부 (내가 작성한 리뷰이거나 구매한 리뷰면 잠금이 해제 된다.)
    var isLock: Bool {
        writenByUser != true && purchased != true
    }
}
