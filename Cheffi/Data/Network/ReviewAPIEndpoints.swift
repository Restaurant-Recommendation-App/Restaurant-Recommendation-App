//
//  ReviewAPIEndpoints.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

struct ReviewAPIEndpoints {
    // 지역맛집 리뷰 조회 API
    static func getReviewsByArea(reviewsByAreaRequest: ReviewsByAreaRequest) -> Endpoint<PaginationResults<[ContentsResponseDTO]>> {
        return Endpoint(path: "api/v1/reviews/areas",
                        method: .get,
                        queryParametersEncodable: reviewsByAreaRequest)
    }
    
    // 태그별 지역맛집 리뷰 조회 API
    static func getReviewsByTag(reviewsByTagRequest: ReviewsByTagRequest) -> Endpoint<PaginationResults<[ContentsResponseDTO]>> {
        return Endpoint(path: "api/v1/reviews/areas/tags",
                        method: .get,
                        queryParametersEncodable: reviewsByTagRequest)
    }
    
    // 리뷰 단건 조회 API
    static func getReview(reviewRequest: ReviewRequest) -> Endpoint<Results<ReviewInfoDTO>> {
        return Endpoint(path: "api/v1/reviews",
                        method: .get,
                        queryParametersEncodable: reviewRequest)
    }
    
    // 리뷰 등록 API
    static func postReviews(registerReviewRequest: RegisterReviewRequest,
                            images: [Data]) -> Endpoint<Results<Int>> {
        let boundary = "Boundary-\(UUID().uuidString)"
        return Endpoint(path: "api/v1/reviews",
                        method: .post,
                        headerParameters: [
                            "Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? "",
                            "Content-Type": "multipart/form-data; boundary=\(boundary)"
                        ],
                        bodyParameters: [
                            "request": registerReviewRequest,
                            "images": images
                        ],
                        bodyEncoding: .multipartFormData,
                        bodyBoundary: boundary)
    }
    
    // 리뷰 구매 API
    static func postReviewPurchase(purchaseReviewRequest: PurchaseReviewRequest) -> Endpoint<Results<Int>> {
        return Endpoint(path: "api/v1/reviews/purchase",
                        method: .post,
                        headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""],
                        bodyParametersEncodable: purchaseReviewRequest)
    }
    
    // 지역별 맛집 조회 API
    static func getAreas(area: String) -> Endpoint<Results<ReviewInfoDTO>> {
        return Endpoint(path: "api/v1/reviews/areas",
                        method: .get,
                        queryParameters: ["area": area])
    }
}
