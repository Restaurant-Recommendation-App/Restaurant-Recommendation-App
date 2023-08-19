//
//  MoreSubCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/19.
//

import UIKit

class MoreSubCell: UITableViewCell {
    
    @IBOutlet private weak var moreTextLabel: UILabel!
    @IBOutlet private weak var moreImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        resetData()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }
    
    // MARK: - Private
    private func setupViews() {
        updateTextLabel(isTitle: false)
    }
    
    private func resetData() {
        moreTextLabel.text = nil
        moreImageView.isHidden = true
    }
    
    // MARK: - Public
    func configure(_ text: String) {
        moreTextLabel.text = text
    }
    
    func updateTextLabel(isTitle: Bool) {
        moreImageView.isHidden = isTitle
        if isTitle {
            moreTextLabel.font = Fonts.suit.weight700.size(16)
            moreTextLabel.textColor = .cheffiGray9
        } else {
            moreTextLabel.font = Fonts.suit.weight500.size(14)
            moreTextLabel.textColor = .cheffiGray9
        }
    }
}
