//
//  ProfileRegistCompletionViewController.swift
//  Cheffi
//
//  Created by ronick on 2024/04/20.
//

import UIKit
import ComposableArchitecture

class ProfileRegistCompletionViewController: UIViewController {
    static func instance<T: ProfileRegistCompletionViewController>(reducer: ProfileRegistCompleReducer) -> T {
        let vc: T = T()
        vc.reducer = reducer
        return vc
    }
    
    private var reducer: ProfileRegistCompleReducer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHostingController(view: ProfileRegistCompletionView(Store(initialState: ProfileRegistCompleReducer.State()) {
            reducer._printChanges()
        }))
    }
}
