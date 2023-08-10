//
//  Int+Extensions.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/29.
//

import Foundation

extension Int {

    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    internal var commaRepresentation: String {
        return Int.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

