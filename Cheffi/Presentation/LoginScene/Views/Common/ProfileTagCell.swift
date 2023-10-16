//
//  ProfileTagCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/2/23.
//

import UIKit

class ProfileTagCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    private enum Constants {
        static let defaultTagBorderColor: UIColor = .cheffiGray2
        static let defatultTagTextColor: UIColor = .cheffiGray8
        static let selectedTagColor: UIColor = .mainCTA
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionStyle()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        resetData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }
    
    private func setupView() {
        self.contentView.layerBorderColor = Constants.defaultTagBorderColor
        self.contentView.layerBorderWidth = 1
        self.contentView.layerCornerRadius = 10
    }
    
    private func resetData() {
        titleLabel.font = Fonts.suit.weight500.size(15)
        titleLabel.textColor = Constants.defatultTagTextColor
    }
    
    private func updateSelectionStyle() {
        if isSelected {
            self.contentView.layerBorderColor = Constants.selectedTagColor
            titleLabel.textColor = Constants.selectedTagColor
        } else {
            self.contentView.layerBorderColor = Constants.defaultTagBorderColor
            titleLabel.textColor = Constants.defatultTagTextColor
        }
    }

    func setTagName(with tag: Tag) {
        titleLabel.text = tag.name
    }
}
