//
//  RestaurantRegistViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

class RestaurantRegistViewController: UIViewController {
    static func instance<T: RestaurantRegistViewController>() -> T {
        let vc: T = .instance(storyboardName: .restaurantRegist)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("------------------------------------------")
        debugPrint("RestaurantRegistViewController viewDidLoad")
        debugPrint("------------------------------------------")
    }
}
