//
//  CheffiContensViewImageCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/31.
//

import UIKit

class CheffiContensViewImageCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var gradationView: UIImageView!
    @IBOutlet private weak var timeAgoLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tasteLabel: UILabel!
    @IBOutlet private weak var tasteBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        setViewsHidden(true)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupViews()
        setViewsHidden(true)
    }
    
    // MARK: - Private
    private func setupViews() {
        imageView.image = nil
    }
    
    // MARK: - Public
    func setImage(_ image: UIImage) {
        self.imageView.image = image
        self.timeAgoLabel.text = "1시간 전"
        self.titleLabel.text = "그시절낭만의 근본 경양식 돈가스"
        self.tasteLabel.text = "취향일치 60%"
    }
    
    func setViewsHidden(_ isHidden: Bool) {
        timeAgoLabel.isHidden = isHidden
        titleLabel.isHidden = isHidden
        tasteLabel.isHidden = isHidden
        tasteBackgroundView.isHidden = isHidden
    }
}
