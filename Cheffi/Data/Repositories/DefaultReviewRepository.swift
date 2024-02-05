//
//  DefaultReviewRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation
import Combine

final class DefaultReviewRepository {
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultReviewRepository: ReviewRepository {
    func getReviews(reviewRequest: ReviewRequest) -> AnyPublisher<(Results<ReviewInfoDTO>, HTTPURLResponse), DataTransferError> {
        let endpoint = ReviewAPIEndpoints.getReview(reviewRequest: reviewRequest)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
    
    func postReviews(registerReviewRequest: RegisterReviewRequest, images: [Data]) -> AnyPublisher<(Results<Int>, HTTPURLResponse), DataTransferError> {
        let endpoint = ReviewAPIEndpoints.postReviews(registerReviewRequest: registerReviewRequest, images: images)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
    
    func postReviewPurchase(purchaseReviewRequest: PurchaseReviewRequest) -> AnyPublisher<(Results<Int>, HTTPURLResponse), DataTransferError> {
        let endpoint = ReviewAPIEndpoints.postReviewPurchase(purchaseReviewRequest: purchaseReviewRequest)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
    
    func getAreas(area: String) -> AnyPublisher<(Results<ReviewInfoDTO>, HTTPURLResponse), DataTransferError> {
        let endpoint = ReviewAPIEndpoints.getAreas(area: area)
        return dataTransferService.request(with: endpoint, on: backgroundQueue)
    }
}
