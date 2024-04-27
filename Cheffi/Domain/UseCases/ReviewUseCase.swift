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
    func getAllTags() -> AnyPublisher<[Tag], DataTransferError>
}

final class DefaultReviewUseCase: ReviewUseCase {
    private let reviewRepository: ReviewRepository
    private let tagRepository: TagRepository
    init(
        reviewRepository: ReviewRepository,
        tagRepository: TagRepository
    ) {
        self.reviewRepository = reviewRepository
        self.tagRepository = tagRepository
    }
    
    func getReviews(reviewRequest: ReviewRequest) -> AnyPublisher<ReviewInfoDTO, DataTransferError> {
        return reviewRepository.getReviews(reviewRequest: reviewRequest)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func postReviews(registerReviewRequest: RegisterReviewRequest, images: [Data]) -> AnyPublisher<Int, DataTransferError> {
        return reviewRepository.postReviews(registerReviewRequest: registerReviewRequest, images: images)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func postReviewPurchase(purchaseReviewRequest: PurchaseReviewRequest) -> AnyPublisher<Int, DataTransferError> {
        return reviewRepository.postReviewPurchase(purchaseReviewRequest: purchaseReviewRequest)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func getAreas(area: String) -> AnyPublisher<ReviewInfoDTO, DataTransferError> {
        return reviewRepository.getAreas(area: area)
            .map({ $0.0.data })
            .eraseToAnyPublisher()
    }
    
    func getAllTags() -> AnyPublisher<[Tag], DataTransferError> {
        return tagRepository.getTags(type: .all)
            .map { $0.0.data.map { $0.toDomain() } }
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
    
    func getAllTags() -> AnyPublisher<[Tag], DataTransferError> {
        Future { promise in
            promise(.success([
                Tag(id: 0, type: .food, name: "한식"),
                Tag(id: 1, type: .food, name: "일식"),
                Tag(id: 2, type: .food, name: "중식"),
                Tag(id: 3, type: .food, name: "샐러드"),
                Tag(id: 4, type: .food, name: "해산물"),
                Tag(id: 5, type: .food, name: "빵집"),
                Tag(id: 6, type: .food, name: "분식"),
                Tag(id: 7, type: .food, name: "면/국수"),
                Tag(id: 8, type: .food, name: "돈까스"),
                Tag(id: 9, type: .food, name: "피자"),
                Tag(id: 10, type: .food, name: "치킨"),
                Tag(id: 10, type: .taste, name: "매콤한"),
                Tag(id: 12, type: .taste, name: "자극적인"),
                Tag(id: 13, type: .taste, name: "달콤한"),
                Tag(id: 14, type: .taste, name: "시원한"),
                Tag(id: 15, type: .taste, name: "깔끔한"),
                Tag(id: 16, type: .taste, name: "깊은맛"),
                Tag(id: 17, type: .taste, name: "감성적인"),
                Tag(id: 18, type: .taste, name: "사진맛집"),
                Tag(id: 19, type: .taste, name: "혼술"),
                Tag(id: 20, type: .taste, name: "혼밥")
            ]))
        }
        .eraseToAnyPublisher()
    }
}
