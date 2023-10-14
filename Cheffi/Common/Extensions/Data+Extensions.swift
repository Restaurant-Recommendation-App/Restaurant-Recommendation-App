//
//  Data+Extensions.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/14/23.
//

import Foundation

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
