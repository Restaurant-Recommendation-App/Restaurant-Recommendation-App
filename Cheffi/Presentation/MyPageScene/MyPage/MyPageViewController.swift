//
//  MyPageViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit
import ComposableArchitecture

class MyPageViewController: UIViewController {
    static func instance<T: MyPageViewController>(reducer: MyPageReducer) -> T {
        let vc: T = .instance(storyboardName: .myPage)
        vc.reducer = reducer
        return vc
    }
    
    private var reducer: MyPageReducer!

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("------------------------------------------")
        debugPrint("MyPageViewController viewDidLoad")
        debugPrint("------------------------------------------")
        
        addHostingController(
            view: MyPageView(
                Store(initialState: MyPageReducer.State()) {
                    reducer._printChanges()
                }
            )
        )
    }
}
