//
//  CheffiContensViewImageCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/31.
//

import UIKit
import Kingfisher

class CheffiContensViewImageCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var gradationView: UIImageView!
    @IBOutlet private weak var relativeTimLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tasteLabel: UILabel!
    @IBOutlet private weak var tasteBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        toggleViewVisibility(isHidden: true)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupViews()
        toggleViewVisibility(isHidden: true)
    }
    
    // MARK: - Private
    private func setupViews() {
        titleLabel.font = Fonts.suit.weight700.size(24)
        titleLabel.textColor = .white
        tasteLabel.font = Fonts.suit.weight700.size(14)
        tasteLabel.textColor = .white
        relativeTimLabel.font = Fonts.suit.weight400.size(14)
        relativeTimLabel.textColor = .cheffiGray3
        imageView.image = nil
    }
    
    // MARK: - Public
    func configure(with photoInfo: ReviewPhotoInfoDTO, reviewInfo: ReviewInfoDTO?) {
        self.imageView.kf.setImage(with: URL(string: photoInfo.photoUrl))
        self.relativeTimLabel.setRelativeTime(from: reviewInfo?.createdDate ?? "")
        self.titleLabel.text = reviewInfo?.title
        self.tasteLabel.text = "취향 \(reviewInfo?.matchedTagNnumber ?? 0)개 일치"
    }
    
    func toggleViewVisibility(isHidden: Bool) {
        relativeTimLabel.isHidden = isHidden
        titleLabel.isHidden = isHidden
        tasteLabel.isHidden = isHidden
        tasteBackgroundView.isHidden = isHidden
        gradationView.isHidden = isHidden
    }
}
