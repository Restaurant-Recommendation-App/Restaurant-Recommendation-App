//
//  RestaurantRegistComposeViewController.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import UIKit
import ComposableArchitecture

class RestaurantRegistComposeViewController: UIViewController {
    private let reducer: RestaurantRegistComposeReducer
    
    init(reducer: RestaurantRegistComposeReducer) {
        self.reducer = reducer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addHostingController(
            view: RestaurantRegistComposeView(
                Store(initialState: RestaurantRegistComposeReducer.State()) {
                    reducer._printChanges()
                }
            )
        )
    }
}
