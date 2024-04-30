//
//  UITextView+Combine.swift
//  Cheffi
//
//  Created by ronick on 2024/04/22.
//

import UIKit
import Combine

extension UITextView {
  func textPublisher() -> AnyPublisher<String, Never> {
      NotificationCenter.default
          .publisher(for: UITextView.textDidChangeNotification, object: self)
          .map { ($0.object as? UITextView)?.text  ?? "" }
          .eraseToAnyPublisher()
  }
}
