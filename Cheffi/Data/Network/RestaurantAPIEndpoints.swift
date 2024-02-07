//
//  RestaurantAPIEndpoints.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/22/23.
//

import Foundation

struct RestaurantAPIEndpoints {
    /// 게시글 등록용 식당 검색 API
    static func getRestaurants(name: String, province: String, city: String) -> Endpoint<Results<[RestaurantInfoDTO]>> {
        return Endpoint(path: "api/v1/restaurants",
                        method: .get,
                        queryParameters: ["name": name,
                                          "province": province,
                                          "city": city])
    }
    
    /// 맛집 등록 API (식당 신규 등록)
    static func registRestaurant(restaurant: RestaurantInfoDTO) -> Endpoint<Results<Int>> {
        return Endpoint(
            path: "/api/v1/restaurants",
            method: .post,
            headerParameters: ["Authorization": UserDefaultsManager.AuthInfo.sessionToken ?? ""],
            bodyParametersEncodable: restaurant
        )
    }
}
