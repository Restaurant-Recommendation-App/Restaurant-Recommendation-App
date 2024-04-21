//
//  String+Extensions.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
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
