//
//  Storyboarded.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit


protocol Storyboarded {
    
    /// 스토리보드 기반 뷰컨트롤러를 생성합니다
    /// - Parameter storyboardName: 해당 뷰컨트롤러가 있는 스토리보드 파일 이름, ex) "Main"
    /// - Returns: 스토리보드 기반 뷰 컨트롤러
    static func instantiate(withStoryboarName storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(withStoryboarName storyboardName: String) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
