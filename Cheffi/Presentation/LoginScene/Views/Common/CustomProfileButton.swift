//
//  CustomProfileButton.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit

final class CustomProfileButton: BaseView {
    
    @IBOutlet private weak var button: UIButton!
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
        setTitle("다음")
        setBaackgroundColor(.cheffiGray3)
        setLayerCornerRadius(10.0)
        button.titleLabel?.font = Fonts.suit.weight600.size(16)
        button.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Public
    func setTitle(_ text: String) {
        button.setTitle(text.localized(), for: .normal)
    }
    
    func setBaackgroundColor(_ color: UIColor?) {
        button.backgroundColor = color
    }
    
    func setLayerCornerRadius(_ value: CGFloat) {
        button.layerCornerRadius = value
    }
    
    // MARK: - Actions
    @IBAction private func didTapButton(_ sender: UIButton) {
        didTapButton?()
    }
}
