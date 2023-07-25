//
//  UIView+Extensions.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/22.
//

import UIKit

extension UIView {
    
    enum BorderEdge {
        case top
        case left
        case bottom
        case right
    }
    
    func addBorderWithColor(layer: CALayer = CALayer(), edge: BorderEdge, color: UIColor, width: CGFloat) {
        layoutIfNeeded()
        let border = layer
        border.backgroundColor = color.cgColor
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height:width)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
    
    func removeBorder(with layer: CALayer) {
        layer.removeFromSuperlayer()
    }
}
