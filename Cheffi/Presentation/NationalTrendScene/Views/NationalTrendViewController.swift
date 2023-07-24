//
//  NationalTrendViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit

final class NationalTrendViewController: UIViewController {
    static func instance<T: NationalTrendViewController>() -> T {
        let vc: T = .instance(storyboardName: .nationalTrend)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("------------------------------------------")
        debugPrint("NationalTrendViewController viewDidLoad")
        debugPrint("------------------------------------------")
    }
}
