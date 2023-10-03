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
    }
    
    func configure(with item: Notification) {
        titleLabel.text = item.notificationType.title
        contentLabel.text = item.content
        iconImageView.image = UIImage(named: item.notificationType.imageName)
        timeAgoLabel.text = "2시간 전"
    }
}
