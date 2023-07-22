//
//  PopupView.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import UIKit

class PopupView: BaseView {
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var cancleButton: UIButton!
    @IBOutlet private weak var findButton: UIButton!
    
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
        let range = (text as NSString).range(of: keyword)

        // 키워드가 텍스트에서 발견되면 빨간색으로 변경
        if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.main, range: range)
        }

        textLabel.attributedText = attributedString
    }
    
    // MARK: - Private
    private func setupViews() {
    }
}
