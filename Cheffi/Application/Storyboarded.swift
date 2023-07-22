//
//  Storyboarded.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit


enum StoryboardName: String {
    case home
    case nationalTrend
    case restaurantRegist
    case myPage
    case popup
    case search
}

extension StoryboardName {
    var name: String { return rawValue.capitalizingFirstLetter() }
}

extension UIViewController {
    class func instance<T>(storyboardName: StoryboardName) -> T where T: UIViewController {
        
        let storyboard = UIStoryboard(name: storyboardName.name, bundle: nil)
        let identifier = String(describing: T.self)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(identifier)")
        }
        return viewController
    }
}
