//
//  RestaurantRegistViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import ComposableArchitecture

class RestaurantRegistViewController: UIViewController {

    static func instance<T: RestaurantRegistViewController>(reducer: RestaurantRegistReducer) -> T {
        let vc: T = .instance(storyboardName: .restaurantRegist)
        vc.reducer = reducer
        return vc
    }

    private var reducer: RestaurantRegistReducer!

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("------------------------------------------")
        debugPrint("RestaurantRegistViewController viewDidLoad")
        debugPrint("------------------------------------------")

        addHostingController(
            view: RestaurantRegistView(
                Store(initialState: RestaurantRegistReducer.State()) {
                    reducer._printChanges()
                }
            )
        )
    }
}
