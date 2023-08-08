//
//  UILabel+Extensions.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/08.
//

import UIKit

extension UILabel {
    func highlightKeyword(_ keyword: String,
                          in text: String,
                          keywordColor: UIColor = .main,
                          defaultColor: UIColor = .black,
                          font: UIFont = UIFont.systemFont(ofSize: 16)) {
        let attributedString = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attributedString.length)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: defaultColor, range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: fullRange)
        
        // 키워드 색상 설정
        let keywordRange = (text as NSString).range(of: keyword)
        if keywordRange.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: keywordColor, range: keywordRange)
        }
        
        self.attributedText = attributedString
    }
}

