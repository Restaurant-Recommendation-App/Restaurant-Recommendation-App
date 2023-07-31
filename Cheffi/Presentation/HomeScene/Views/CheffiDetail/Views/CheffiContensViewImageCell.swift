//
//  CheffiContensViewImageCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/31.
//

import UIKit

class CheffiContensViewImageCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupViews()
    }

    // MARK: - Private
    private func setupViews() {
        imageView.image = nil
    }
    
    // MARK: - Public
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
}
