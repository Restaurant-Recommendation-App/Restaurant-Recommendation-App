//
//  ToastView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/20/23.
//

import UIKit

final class ToastView: BaseView {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        messageLabel.font = Fonts.suit.weight500.size(18)
        messageLabel.textColor = .white
        
        imageView.layer.cornerRadius = 12
        contentView.layer.cornerRadius = 10
    }
    
    // MARK: - Public
    func show(in parentView: UIView, message: String, duration: TimeInterval = 2.0) {
        messageLabel.text = message
        parentView.addSubview(self)
        self.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        self.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: [], animations: {
                self.alpha = 0.0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        })
    }
}
