//
//  Fonts.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/08.
//

import UIKit

protocol FontType {
    var name: String { get }
}

// MARK: - Fonts
enum Fonts {
    case regular
    case bold
    case semibold
    case medium
    
    enum suit: String, FontType {
        case bold = "SUIT-Bold"
        case extraBold = "SUIT-ExtraBold"
        case extraLight = "SUIT-ExtraLight"
        case heavy = "SUIT-Heavy"
        case ligth = "SUIT-Light"
        case medium = "SUIT-Medium"
        case regular = "SUIT-Regular"
        case semiBold = "SUIT-SemiBold"
        case thin = "SUIT-Thin"
    }
}

extension Fonts {
    func size(_ size: CGFloat) -> UIFont {
        switch self {
        case .regular:
            if let font = UIFont(name: "AppleSDGothicNeo-Regular", size: size) {
                return font
            }
            
            return UIFont.systemFont(ofSize: size)
        case .bold:
            if let font = UIFont(name: "AppleSDGothicNeo-Bold", size: size) {
                return font
            }
            
            return UIFont.systemFont(ofSize: size, weight: .bold)
        case .semibold:
            if let font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: size) {
                return font
            }
            
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        case .medium:
            if let font = UIFont(name: "AppleSDGothicNeo-Medium", size: size) {
                return font
            }
            
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
    }
}

// MARK: - FontType
extension FontType where Self: RawRepresentable, Self.RawValue == String {
    var name: String { return self.rawValue }
    
    func size(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.name, size: size)!
    }
}

extension UIFont: FontType {
    var name: String { return self.fontName }
}
