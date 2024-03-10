//
//  String+Extensions.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import Foundation
import SwiftUI

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func highlightedText(keyword: String) -> Text {
        guard !isEmpty && !keyword.isEmpty else { return Text(self) }
        
        var result: Text!
        let parts = components(separatedBy: keyword)
        for i in parts.indices {
            result = (result == nil ? Text(parts[i]) : result + Text(parts[i]))
            if i != parts.count - 1 {
                result = result + Text(keyword).foregroundColor(.mainCTA)
            }
        }
        return result ?? Text(self)
    }
}
