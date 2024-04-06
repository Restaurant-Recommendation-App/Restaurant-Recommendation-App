//
//  AgreementViewContrroller.swift
//  Cheffi
//
//  Created by ronick on 2024/03/31.
//

import UIKit
import ComposableArchitecture

class AgreementViewContrroller: UIViewController {
    static func instance<T: AgreementViewContrroller>(reducer: AgreementReducer) -> T {
        let vc: T = T()
        vc.reducer = reducer
        return vc
    }
    
    private var reducer: AgreementReducer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint("------------------------------------------")
        debugPrint("AgreementViewContrroller viewDidLoad")
        debugPrint("------------------------------------------")
        
        addHostingController(view: AgreementView(Store(initialState: AgreementReducer.State()) {
            reducer._printChanges()
        }))
    }
}
