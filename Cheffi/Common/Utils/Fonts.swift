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
        case weight300 = "SUIT-Light"
        case weight400 = "SUIT-Regular"
        case weight500 = "SUIT-Medium"
        case weight600 = "SUIT-SemiBold"
        case weight700 = "SUIT-Bold"
        case weight800 = "SUIT-ExtraBold"
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
