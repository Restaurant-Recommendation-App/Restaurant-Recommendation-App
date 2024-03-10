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

final class PreviewReviewUseCase: ReviewUseCase {
    func getReviews(reviewRequest: ReviewRequest) -> AnyPublisher<ReviewInfoDTO, DataTransferError> {
        Future { promise in
            promise(.success(
                ReviewInfoDTO(
                    id: 0,
                    title: "맛집 찾았다", 
                    text: "맛집 찾았다 맛집 찾았다 맛집 찾았다 맛집 찾았다 맛집 찾았다 맛집 찾았다 맛집 찾았다",
                    bookmarked: false,
                    ratedByUser: true,
                    ratingType: .good,
                    createdDate: nil,
                    timeLeftToLock: 300000,
                    matchedTagNum: nil, 
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: [
                        MenuDTO(name: "김밥", price: 3500, description: nil),
                        MenuDTO(name: "참치김밥", price: 4500, description: nil)
                    ]
                )
            ))
        }
        .eraseToAnyPublisher()
    }
    
    func postReviews(registerReviewRequest: RegisterReviewRequest, images: [Data]) -> AnyPublisher<Int, DataTransferError> {
        Future { promise in
            promise(.success(1))
        }
        .eraseToAnyPublisher()
    }
    
    func postReviewPurchase(purchaseReviewRequest: PurchaseReviewRequest) -> AnyPublisher<Int, DataTransferError> {
        Future { promise in
            promise(.success(1))
        }
        .eraseToAnyPublisher()
    }
    
    func getAreas(area: String) -> AnyPublisher<ReviewInfoDTO, DataTransferError> {
        Future { promise in
            promise(.success(
                ReviewInfoDTO(
                    id: 0,
                    title: "맛집 찾았다",
                    text: "맛집 찾았다 맛집 찾았다 맛집 찾았다 맛집 찾았다 맛집 찾았다 맛집 찾았다 맛집 찾았다",
                    bookmarked: false,
                    ratedByUser: true,
                    ratingType: .good,
                    createdDate: nil,
                    timeLeftToLock: 300000,
                    matchedTagNum: nil,
                    restaurant: nil,
                    writer: nil,
                    ratings: nil,
                    photos: nil,
                    menus: [
                        MenuDTO(name: "김밥", price: 3500, description: nil),
                        MenuDTO(name: "참치김밥", price: 4500, description: nil)
                    ]
                )
            ))
        }
        .eraseToAnyPublisher()
    }
    
    
}
