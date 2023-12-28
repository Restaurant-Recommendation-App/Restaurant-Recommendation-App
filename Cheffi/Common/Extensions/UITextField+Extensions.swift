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
    
    func addLeftIcon(withImage image: UIImage?, imageSize: CGSize) {
        let leftPadding: CGFloat = 16
        let rightPadding: CGFloat = 8
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding + imageSize.width + rightPadding, height: frame.height))
        let centerY = leftView.frame.midY - (imageSize.height / 2)
        let imageView = UIImageView(frame: CGRect(x: leftPadding, y: centerY, width: imageSize.width, height: imageSize.height))
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        leftView.addSubview(imageView)
        
        self.leftView = leftView
        self.leftViewMode = .always
    }
}
