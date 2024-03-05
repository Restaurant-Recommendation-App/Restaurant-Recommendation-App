//
//  ReviewComposeViewController.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import UIKit
import ComposableArchitecture

class ReviewComposeViewController: UIViewController {
    private let reducer: ReviewComposeReducer
    private let restaurant: RestaurantInfoDTO
    
    init(
        reducer: ReviewComposeReducer,
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
            view: ReviewComposeView(
                Store(initialState: ReviewComposeReducer.State(
                    restaurant: restaurant, 
                    titleTextFieldBarState: TextFieldBarReducer.State(
                        placeHolder: "\(restaurant.name) 맛있어요",
                        maxCount: 30
                    )
                )) {
                    reducer._printChanges()
                }
            )
        )
    }
}
