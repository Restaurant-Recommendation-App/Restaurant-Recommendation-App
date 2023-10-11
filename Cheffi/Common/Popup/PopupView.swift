//
//  PopupView.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import UIKit

class PopupView: BaseView {
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var subTextLabel: UILabel!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    
    var didTapLeftHandler: (() -> Void)?
    var didTapRightHandler: (() -> Void)?
    
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
        subTextLabel.font = Fonts.suit.weight400.size(15)
        subTextLabel.textColor = .cheffiGray6
    }
    
    // MARK: - Public
    func highlightKeyword(_ keyword: String, in text: String) {
        textLabel.highlightKeyword(keyword, in: text, font: Fonts.suit.weight400.size(16), keywordFont: Fonts.suit.weight600.size(16))
    }
    
    func setTitleLabelFont(font: UIFont) {
        textLabel.font = font
    }
    
    func setTitleLabelTextColor(color: UIColor) {
        textLabel.textColor = color
    }
    
    func setSubTextLabelText(text: String) {
        subTextLabel.isHidden = text.isEmpty
        subTextLabel.text = text
    }
    
    func setLeftButtonText(text: String) {
        leftButton.setTitle(text, for: .normal)
    }
    
    func setRightButtonText(text: String) {
        rightButton.setTitle(text, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        didTapLeftHandler?()
    }
    
    @IBAction func didTapRightButton(_ sender: UIButton) {
        didTapRightHandler?()
    }
}
