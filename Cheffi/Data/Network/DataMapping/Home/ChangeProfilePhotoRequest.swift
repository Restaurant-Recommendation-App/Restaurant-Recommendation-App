//
//  ChangeProfilePhotoRequest.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/16/23.
//

import Foundation

struct ChangeProfilePhotoRequest: Codable {
    let defaults: Bool
    let introduction: String
    
    enum CodingKeys: String, CodingKey {
        case defaults = "default"
        case introduction = "introduction"
    }
}
