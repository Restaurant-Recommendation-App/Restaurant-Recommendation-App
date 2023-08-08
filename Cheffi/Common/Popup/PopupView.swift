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
    
    // MARK: - Private
    private func setupViews() {
    }
    
    // MARK: - Public
    func highlightKeyword(_ keyword: String, in text: String) {
        textLabel.highlightKeyword(keyword, in: text, defaultColor: .cheffiGray9, font: Fonts.suit.ligth.size(16))
    }
    
    // MARK: - Actions
    @IBAction func didTapCancel(_ sender: UIButton) {
        didTapCancelHandler?()
    }
    
    @IBAction func didTapFind(_ sender: UIButton) {
        didTapFindHandler?()
    }
}
