//
//  NotificationCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/3/23.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var timeAgoLabel: UILabel!
    @IBOutlet private weak var selectionImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        resetData()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }
    
    private func resetData() {
        titleLabel.text = nil
        contentLabel.text = nil
        iconImageView.image = nil
        timeAgoLabel.text = nil
    }
    
    private func setupViews() {
        titleLabel.font = Fonts.suit.weight400.size(15)
        titleLabel.textColor = .cheffiGray6
        contentLabel.font = Fonts.suit.weight500.size(15)
        contentLabel.textColor = .cheffiGray8
        timeAgoLabel.font = Fonts.suit.weight400.size(12)
        timeAgoLabel.textColor = .cheffiGray5
        
        selectionImageView.image = UIImage(named: "icNotificationDeselect")
        selectionImageView.isHidden = true
    }
    
    func configure(with item: Notification, isDeleting: Bool) {
        titleLabel.text = item.category.title
        contentLabel.text = item.content
        iconImageView.image = UIImage(named: item.category.imageName)
        timeAgoLabel.text = "2시간 전"
        timeAgoLabel.isHidden = isDeleting
        selectionImageView.isHidden = !isDeleting
    }
    
    func updateSelectionButton() {
        let image = self.isSelected ? UIImage(named: "icNotificationSelect") : UIImage(named: "icNotificationDeselect")
        selectionImageView.image = image
    }
    
    func updateContentViewBackgroundColor(_ isChecked: Bool) {
        self.contentView.backgroundColor = isChecked ? .cheffiWhite05 : .white
    }
}
