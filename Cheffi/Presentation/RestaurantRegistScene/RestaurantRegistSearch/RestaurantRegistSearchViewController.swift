//
//  RestaurantRegistSearchViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import ComposableArchitecture

class RestaurantRegistSearchViewController: UIViewController {

    static func instance<T: RestaurantRegistSearchViewController>(reducer: RestaurantRegistSearchReducer) -> T {
        let vc: T = .instance(storyboardName: .restaurantRegist)
        vc.reducer = reducer
        return vc
    }

    private var reducer: RestaurantRegistSearchReducer!

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("------------------------------------------")
        debugPrint("RestaurantRegistSearchViewController viewDidLoad")
        debugPrint("------------------------------------------")

        addHostingController(
            view: RestaurantRegistSearchView(
                Store(initialState: RestaurantRegistSearchReducer.State()) {
                    reducer._printChanges()
                }
            )
        )
    }
}
