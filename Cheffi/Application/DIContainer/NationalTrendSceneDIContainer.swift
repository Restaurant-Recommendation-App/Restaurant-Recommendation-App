//
//  NationalTrendSceneDIContainer.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

final class NationalTrendSceneDIContainer: NationalTrendFlowCoodinatorDependencies {
    func makeNationalTrendFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> NationalTrendFlowCoodinator {
        return NationalTrendFlowCoodinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self)
    }
    
    func makeViewController() -> UIViewController {
        return NationalTrendViewController.instance()
    }
    
    func makePopupViewController(text: String, subText: String, keyword: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String, leftHandler: (() -> Void)?, rightHandler: (() -> Void)?) -> PopupViewController {
        return PopupViewController.instance(text: text,
                                            subText: subText,
                                            keyword: keyword,
                                            popupState: popupState,
                                            leftButtonTitle: leftButtonTitle,
                                            rightButtonTitle: rightButtonTitle,
                                            leftHandler: leftHandler,
                                            rightHandler: rightHandler)
    }
}
