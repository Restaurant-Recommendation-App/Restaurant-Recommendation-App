//
//  RestaurantRegistViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class RestaurantRegistViewController: UIViewController {

    static func instance<T: RestaurantRegistViewController>(feature: RestaurantRegistReducer) -> T {
        let vc: T = .instance(storyboardName: .restaurantRegist)
        vc.feature = feature
        return vc
    }

    private var feature: RestaurantRegistReducer!

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("------------------------------------------")
        debugPrint("RestaurantRegistViewController viewDidLoad")
        debugPrint("------------------------------------------")

        addHostingController(
            view: RestaurantRegistView(
                Store(initialState: RestaurantRegistReducer.State()) {
                    feature._printChanges()
                }
            )
        )
    }
}
