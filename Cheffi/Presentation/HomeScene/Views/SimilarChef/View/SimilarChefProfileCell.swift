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
        
    }
    
    // MARK: - private
    private func setupViews() {
        self.contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
