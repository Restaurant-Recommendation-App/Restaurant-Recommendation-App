//
//  CheffiLocationView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/29.
//

import UIKit

class CheffiLocationView: BaseView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var copyButton: UIButton!
    
    var didTapCopyHandler: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setLocation(_ location: Location) {
        addressLabel.text = location.address
    }
    
    // MARK: - Private
    private func setupViews() {
        titleLabel.text = "위치".localized()
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "복사".localized(), attributes: underlineAttribute)
        copyButton.setAttributedTitle(underlineAttributedString, for: .normal)
    }
    
    // MARK: - Action
    @IBAction private func didTapCopy(_ sender: UIButton) {
        guard let text = self.addressLabel.text else { return }
        didTapCopyHandler?(text)
    }
}
