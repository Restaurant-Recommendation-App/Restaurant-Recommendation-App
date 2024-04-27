//
//  NationalTrendViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import ComposableArchitecture

final class NationalTrendViewController: UIViewController {
    static func instance<T: NationalTrendViewController>(reducer: NationalTrendReducer) -> T {
        let vc: T = .instance(storyboardName: .nationalTrend)
        vc.reducer = reducer
        return vc
    }
    
    private var reducer: NationalTrendReducer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("------------------------------------------")
        debugPrint("NationalTrendViewController viewDidLoad")
        debugPrint("------------------------------------------")
        
        addHostingController(
            view: NationalTrendView(
                Store(initialState: NationalTrendReducer.State()) {
                    reducer._printChanges()
                }
            )
        )
        
        // 커밍순 팝업이 overFullScreen 프레젠테이션 스타일로 표시 되어 presentingViewController 의 뷰가 배경에 비쳐보일 수 있도록 hosting 뷰컨트롤러의 뷰 배경색을 clear로 지정.
        children.first?.view.backgroundColor = .clear
    }
}
