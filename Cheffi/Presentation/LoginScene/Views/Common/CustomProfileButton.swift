//
//  CustomProfileButton.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit

final class CustomProfileButton: BaseView {
    
    @IBOutlet private weak var button: UIButton!
    var isEnable: Bool = false {
        didSet {
            button.isEnabled = isEnable
            if isEnable {
                setBackgroundColor(.mainCTA)
                button.setTitleColor(.white, for: .normal)
            } else {
                setBackgroundColor(.cheffiGray1)
                button.setTitleColor(.cheffiGray5, for: .disabled)
            }
        }
    }
    var didTapButton: (() -> Void)?
    
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
        setTitle("다음".localized(), for: .normal)
        setBackgroundColor(.cheffiGray3)
        setLayerCornerRadius(10.0)
        button.titleLabel?.font = Fonts.suit.weight600.size(16)
        button.setTitleColor(.white, for: .normal)
        isEnable = false
    }
    
    // MARK: - Public
    func setTitle(_ text: String, for state: UIControl.State) {
        button.setTitle(text.localized(), for: state)
    }
    
    func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        button.setTitleColor(color, for: state)
    }
    
    func setTitleFont(font: UIFont) {
        button.titleLabel?.font = font
    }
    
    func setBackgroundColor(_ color: UIColor?) {
        button.backgroundColor = color
    }
    
    func setLayerCornerRadius(_ value: CGFloat) {
        button.layerCornerRadius = value
    }
    
    func setLayerBorderWidth(_ value: CGFloat) {
        button.layerBorderWidth = value
    }
    
    func setLayerBorderColor(_ color: UIColor) {
        button.layerBorderColor = color
    }
    
    // MARK: - Actions
    @IBAction private func didTapButton(_ sender: UIButton) {
        didTapButton?()
    }
    
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        button.controlPublisher(for: event)
    }
}
