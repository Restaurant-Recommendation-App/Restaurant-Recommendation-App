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
                          font: UIFont,
                          keywordFont: UIFont) {  // keywordFont 파라미터 추가
        let attributedString = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attributedString.length)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: defaultColor, range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: fullRange)
        
        // 키워드 색상 설정
        let keywordRange = (text as NSString).range(of: keyword)
        if keywordRange.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: keywordColor, range: keywordRange)
            attributedString.addAttribute(NSAttributedString.Key.font, value: keywordFont, range: keywordRange)
        }
        
        self.attributedText = attributedString
    }
    
    func setRelativeTime(from dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = dateFormatter.date(from: dateString) else {
            self.text = "알 수 없는 시간"
            return
        }
        
        let now = Date()
        let elapsedTimeInSeconds = now.timeIntervalSince(date)
        
        switch elapsedTimeInSeconds {
        case 0..<3600: // less than an hour
            self.text = "방금 전"
        case 3600..<(3600 * 24): // 1 hour to 24 hours
            let hours = Int(elapsedTimeInSeconds / 3600)
            self.text = "\(hours)시간 전"
        case (3600 * 24)..<(3600 * 24 * 30): // 1 day to 30 days
            let days = Int(elapsedTimeInSeconds / (3600 * 24))
            self.text = "\(days)일 전"
        default: // more than 30 days
            let months = Int(elapsedTimeInSeconds / (3600 * 24 * 30))
            self.text = "\(months)달 전"
        }
    }
}


