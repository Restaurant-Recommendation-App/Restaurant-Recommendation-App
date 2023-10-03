//
//  NotificationHeaderView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import UIKit


final class NotificationHeaderView: BaseView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    var didTapDeleteHandler: ((Bool) -> Void)?
    
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
        titleLabel.font = Fonts.suit.weight700.size(24)
        titleLabel.textColor = .cheffiBlack
        titleLabel.text = "알림".localized()
        
        deleteButton.titleLabel?.font = Fonts.suit.weight500.size(15)
        deleteButton.setTitleColor(.cheffiGray6, for: .normal)
        deleteButton.setTitleColor(.cheffiGray6, for: .selected)
        deleteButton.setTitle("삭제".localized(), for: .normal)
        deleteButton.setTitle("전체삭제".localized(), for: .selected)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func didTapDelete(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        didTapDeleteHandler?(sender.isSelected)
    }
}
