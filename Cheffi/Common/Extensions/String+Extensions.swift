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

// MAKR: - Validation
extension String {
    func isValidNickname() -> Bool {
        let nicknameRegEx = "[a-zA-Z0-9가-힣]{2,9}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegEx)
        return predicate.evaluate(with: self)
    }
    
    func containsKoreanVowelsAndConsonants() -> Bool {
        let koreanRegEx = "[ㄱ-ㅎㅏ-ㅣ]"
        return self.range(of: koreanRegEx, options: .regularExpression) != nil
    }
}
