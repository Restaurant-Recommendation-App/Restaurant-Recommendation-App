//
//  PurchaseReviewRequest.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

struct PurchaseReviewRequest: Codable {
    let reviewId: Int
    
    enum CodingKeys: String, CodingKey {
        case reviewId = "review_id"
    }
}
