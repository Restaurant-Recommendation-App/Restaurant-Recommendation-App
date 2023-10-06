//
//  UIViewController+Extensions.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import UIKit

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
}
