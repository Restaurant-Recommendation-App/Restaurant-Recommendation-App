//
//  RestaurantInfoComposeViewController.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import UIKit
import ComposableArchitecture

class RestaurantInfoComposeViewController: UIViewController {
    private let reducer: RestaurantInfoComposeReducer
    private let restaurant: RestaurantInfoDTO
    
    init(
        reducer: RestaurantInfoComposeReducer,
        restaurant: RestaurantInfoDTO
    ) {
        self.reducer = reducer
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addHostingController(
            view: RestaurantInfoComposeView(
                Store(initialState: RestaurantInfoComposeReducer.State(
                    restaurant: restaurant
                )) {
                    reducer._printChanges()
                }
            )
        )
    }
}
