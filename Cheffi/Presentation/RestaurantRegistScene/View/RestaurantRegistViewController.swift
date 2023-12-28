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

    static func instance<T: RestaurantRegistViewController>(feature: RestaurantRegistFeature) -> T {
        let vc: T = .instance(storyboardName: .restaurantRegist)
        vc.feature = feature
        return vc
    }

    private var feature: RestaurantRegistFeature!

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("------------------------------------------")
        debugPrint("RestaurantRegistViewController viewDidLoad")
        debugPrint("------------------------------------------")

        addHostingController(
            view: RestaurantRegistView(
                store: Store(initialState: RestaurantRegistFeature.State()) {
                    feature._printChanges()
                }
            )
        )
    }
}
