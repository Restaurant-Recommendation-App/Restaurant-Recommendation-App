//
//  UITextField+Extensions.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/09.
//

import Combine
import UIKit

extension UITextField {
    var textDidChangePublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { _ in
                return self.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}
