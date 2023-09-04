//
//  ShowAllContentsButton.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/27.
//

import UIKit

enum ShowAllContentsDirection {
    case right
    case down
}

class ShowAllContentsButton: BaseView {
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    var didTapViewAllHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setTItle(_ text: String?, direction: ShowAllContentsDirection) {
        titleLabel.text = text
        switch direction {
        case .right:
            imageView.image = UIImage(named: "icRightArrowGray")
        case .down:
            imageView.image = UIImage(named: "icDownArrowGray")
        }
    }
    
    // MARK: - Private
    private func setupViews() {
        button.layerBorderColor = .cheffiGray2
        button.layerBorderWidth = 1.0
        button.layerCornerRadius = 10.0
        
        // imageView
        imageView.image = UIImage(named: "icRightArrowGray")
        
        // label
        titleLabel.textColor = UIColor(hexString: "808080")
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
    }
    
    // MARK: - Actions
    @IBAction private func didTapViewAll(_ sender: UIButton) {
        didTapViewAllHandler?()
    }
    
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        button.controlPublisher(for: event)
    }
}
