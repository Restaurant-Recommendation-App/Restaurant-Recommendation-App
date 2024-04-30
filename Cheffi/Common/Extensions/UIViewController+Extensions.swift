//
//  UIViewController+Extensions.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import UIKit
import SwiftUI

extension UIViewController {
    var topSafeArea: CGFloat {
        get {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0.0 }
            return windowScene.windows.first?.safeAreaInsets.top ?? 0.0
        }
    }
    
    var bottomSafeArea: CGFloat {
        get {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0.0 }
            return windowScene.windows.first?.safeAreaInsets.bottom ?? 0.0
        }
    }
    
    func dismissOne(amimated: Bool, _ completion: (() -> Swift.Void)? = nil) {
        view.endEditing(true)
        
        if let navi = navigationController {
            navi.dismiss(animated: amimated, completion: completion)
        } else {
            dismiss(animated: amimated, completion: completion)
        }
    }
    
    func dismissOrPop(amimated: Bool, _ completion: (() -> Swift.Void)? = nil) {
        if let navi = navigationController, self != navi.viewControllers.first {
            navi.popViewController(animated: amimated, completion)
        } else {
            dismiss(animated: amimated, completion: completion)
        }
    }
    
    func dismissAll(_ completion: (() -> Swift.Void)? = nil) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first(where: { $0.isKeyWindow })
        window?.rootViewController?.dismiss(animated: true, completion: completion)
    }
    
    func findPresentedViewController<T: UIViewController>(ofType type: T.Type) -> T? {
        var currentVC = self.presentedViewController
        while currentVC != nil {
            if let desiredVC = currentVC as? T {
                return desiredVC
            }
            currentVC = currentVC?.presentedViewController
        }
        return nil
    }
    
    /// SwiftUI 뷰 계층을 관리하는 UIKit 뷰컨트롤러를 child로 추가하고 SwiftUI 뷰도 추가합니다.
    /// - Parameter view: SwiftUI View 프로토콜을 채택한 구조체.
    func addHostingController(view: some View) {
        let hostingVC = UIHostingController(rootView: view)
        let swiftUIView = hostingVC.view!
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false

        self.addChild(hostingVC)

        self.view.addSubview(swiftUIView)

        swiftUIView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // https://www.advancedswift.com/animate-with-ios-keyboard-swift/
    func animateWithKeyboard(notification: NSNotification,
                             animations: ((_ keyboardFrame: CGRect) -> Void)?,
                             completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        
        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
        
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!
        
        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }
        
        if let completion = completion {
            animator.addCompletion(completion)
        }
        
        // Start the animation
        animator.startAnimation()
    }

}
