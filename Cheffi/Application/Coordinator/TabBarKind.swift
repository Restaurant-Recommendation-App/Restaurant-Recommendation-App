//
//  TabBarKind.swift
//  Cheffi
//
//  Created by 김문옥 on 1/20/24.
//

import Foundation

enum TabBarKind: String {
    case home = "홈"
    case nationalTrend = "전국트렌드"
    case restaurantRegist = "맛집등록"
    case myPage = "마이페이지"
    
    var tabBarNo: Int {
        switch self {
        case .home: return 0
        case .nationalTrend: return 1
        case .restaurantRegist: return 2
        case .myPage: return 3
        }
    }
}
