//
//  PopupView.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import UIKit

class PopupView: BaseView {
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var findButton: UIButton!
    
    var didTapCancelHandler: (() -> Void)?
    var didTapFindHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setText(text: String, keyword: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: fullRange)

        // 키워드 색상 main color
        let keywordRange = (text as NSString).range(of: keyword)
        if keywordRange.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.main, range: keywordRange)
        }

        textLabel.attributedText = attributedString
    }
    
    // MARK: - Private
    private func setupViews() {
    }
    
    // MARK: - Actions
    @IBAction func didTapCancel(_ sender: UIButton) {
        didTapCancelHandler?()
    }
    
    @IBAction func didTapFind(_ sender: UIButton) {
        didTapFindHandler?()
    }
}
