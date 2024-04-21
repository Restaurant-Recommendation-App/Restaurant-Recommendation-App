//
//  RouteStep.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import Foundation

enum RouteStep {
    case popToNavigationController
    case dismissRestaurantRegist
    case dismissTermsView
    case pushRestaurantRegistSearch
    case pushRestaurantRegistCompose
    case pushAgreementViewController
    case pushUserRegistComplViewController
    case pushProfileSetupViewController
    case pushReviewCompose(info: RestaurantInfoDTO)
    case presentCamera(
        isPresentPhotoAlbum: Bool,
        dismissCompletion: ((Data?) -> Void)?
    )
    case presentPhotoAlbum(
        dismissCompletion: (([Data?]) -> Void)?
    )
    case pushReviewHashtags(ReviewHashtagsActionType)
}
