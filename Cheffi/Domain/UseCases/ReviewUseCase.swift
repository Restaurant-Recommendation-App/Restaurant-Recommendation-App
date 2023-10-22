//
//  ReviewUseCase.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation
import Combine

protocol ReviewUseCase {
    func getReviews(reviewRequest: ReviewRequest) -> AnyPublisher<ReviewInfoDTO, DataTransferError>
    func postReviews(registerReviewRequest: RegisterReviewRequest,
                     images: [Data]) -> AnyPublisher<Int, DataTransferError>
    func postReviewPurchase(purchaseReviewRequest: PurchaseReviewRequest) -> AnyPublisher<Int, DataTransferError>
    func getAreas(area: String) -> AnyPublisher<ReviewInfoDTO, DataTransferError>
}

final class DefaultReviewUseCase: ReviewUseCase {
    private let repository: ReviewRepository
    init(repository: ReviewRepository) {
        self.repository = repository
    }
    
    func getReviews(reviewRequest: ReviewRequest) -> AnyPublisher<ReviewInfoDTO, DataTransferError> {
        return repository.getReviews(reviewRequest: reviewRequest)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func postReviews(registerReviewRequest: RegisterReviewRequest, images: [Data]) -> AnyPublisher<Int, DataTransferError> {
        return repository.postReviews(registerReviewRequest: registerReviewRequest, images: images)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func postReviewPurchase(purchaseReviewRequest: PurchaseReviewRequest) -> AnyPublisher<Int, DataTransferError> {
        return repository.postReviewPurchase(purchaseReviewRequest: purchaseReviewRequest)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func getAreas(area: String) -> AnyPublisher<ReviewInfoDTO, DataTransferError> {
        return repository.getAreas(area: area)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
}
