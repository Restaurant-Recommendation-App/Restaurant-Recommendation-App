//
//  MyPageViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit

class MyPageViewController: UIViewController {
    static func instance<T: MyPageViewController>() -> T {
        let vc: T = .instance(storyboardName: .myPage)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("------------------------------------------")
        debugPrint("MyPageViewController viewDidLoad")
        debugPrint("------------------------------------------")
    }
}
