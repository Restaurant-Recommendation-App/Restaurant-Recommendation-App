//
//  ReviewRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation
import Combine

protocol ReviewRepository {
    func getReviews(reviewRequest: ReviewRequest) -> AnyPublisher<(Results<GetReviewResponse>, HTTPURLResponse), DataTransferError>
    func postReviews(registerReviewRequest: RegisterReviewRequest,
                     images: [Data]) -> AnyPublisher<(Results<Int>, HTTPURLResponse), DataTransferError>
    func postReviewPurchase(purchaseReviewRequest: PurchaseReviewRequest) -> AnyPublisher<(Results<Int>, HTTPURLResponse), DataTransferError>
    func getAreas(area: String) -> AnyPublisher<(Results<ReviewInfoDTO>, HTTPURLResponse), DataTransferError>
}
