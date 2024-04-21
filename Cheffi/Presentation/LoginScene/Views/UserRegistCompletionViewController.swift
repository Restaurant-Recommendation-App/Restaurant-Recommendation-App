//
//  UserRegistCompletionViewController.swift
//  Cheffi
//
//  Created by ronick on 2024/04/16.
//

import UIKit
import ComposableArchitecture

final class UserRegistCompletionViewController: UIViewController {
    static func instance<T: UserRegistCompletionViewController>(reducer: UserRegistComplReducer) -> T {
        let vc: T = T()
        vc.reducer = reducer
        return vc
    }
    
    private var reducer: UserRegistComplReducer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHostingController(view: UserRegistCompletionView(Store(initialState: UserRegistComplReducer.State()) {
            reducer._printChanges()
        }))
    }
}
