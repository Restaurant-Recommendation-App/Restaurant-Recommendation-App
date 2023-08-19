//
//  MoreCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/19.
//

import UIKit

class MoreCell: UITableViewCell {
    
    @IBOutlet private weak var titleImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

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
        titleLabel.font = Fonts.suit.weight600.size(16)
        titleLabel.textColor = .cheffiGray9
    }
    
    private func resetData() {
        titleImageView.image = nil
        titleLabel.text = nil
    }
    
    // MARK: - Public
    func configure(moreMenu: MoreMenu) {
        titleLabel.text = moreMenu.title
        titleImageView.image = moreMenu.image
    }
}
