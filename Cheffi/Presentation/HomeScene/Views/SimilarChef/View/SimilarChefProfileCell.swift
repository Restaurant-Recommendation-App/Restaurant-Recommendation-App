//
//  SimilarChefProfileCell.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit

class SimilarChefProfileCell: UICollectionViewCell {

    private let profileView = ProfileView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func configure(with nickname: String) {
        profileView.setNickname(nickname)
    }
    
    // MARK: - private
    private func setupViews() {
        self.layerCornerRadius = 10
        self.layerBorderWidth = 1
        self.layerBorderColor = UIColor(hexString: "C5C5C5")
        
        self.contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
