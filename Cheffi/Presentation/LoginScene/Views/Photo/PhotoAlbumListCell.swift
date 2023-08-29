//
//  PhotoAlbumListCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/13.
//

import UIKit

class PhotoAlbumListCell: UITableViewCell {
    
    @IBOutlet private weak var firstImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageCountLabel: UILabel!

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
        titleLabel.textColor = .cheffiBlack
        titleLabel.font = Fonts.suit.weight600.size(14)
        imageCountLabel.textColor = .cheffiGray4
        imageCountLabel.font = Fonts.suit.weight600.size(12)
    }
    
    private func resetData() {
        firstImageView.image = nil
        titleLabel.text = nil
        imageCountLabel.text = "0"
    }
    
    // MARK: - Public
    func configre(with albumInfo: AlbumInfo) {
        if let asset = albumInfo.album.firstObject {
            PhotoService.shared.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill) { [weak self] image in
                DispatchQueue.main.async {
                    self?.firstImageView.image = image
                }
            }
        }
        titleLabel.text = albumInfo.name
        imageCountLabel.text = albumInfo.album.count.string
    }
}
