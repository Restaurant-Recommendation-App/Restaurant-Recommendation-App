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
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // 서버에서 반환된 시간이 UTC라고 가정
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let now = Date()
            
            let timeZone = TimeZone.current
            let secondsFromGMT = timeZone.secondsFromGMT(for: now)
            let currentKST = now.addingTimeInterval(TimeInterval(secondsFromGMT + 32400)) // 현재 시간을 KST로 변환
            
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: currentKST)
            
            var relativeString = ""
            
            if let year = components.year, year > 0 {
                relativeString = "\(year)년 전"
            } else if let month = components.month, month > 0 {
                relativeString = "\(month)달 전"
            } else if let day = components.day, day > 0 {
                relativeString = "\(day)일 전"
            } else if let hour = components.hour, hour > 0 {
                relativeString = "\(hour)시간 전"
            } else if let minute = components.minute, minute > 0 {
                relativeString = "\(minute)분 전"
            } else if let second = components.second, second > 0 {
                relativeString = "\(second)초 전"
            } else {
                relativeString = "방금"
            }
            
            self.text = relativeString
        } else {
            self.text = "알 수 없는 시간"
        }
    }
}


