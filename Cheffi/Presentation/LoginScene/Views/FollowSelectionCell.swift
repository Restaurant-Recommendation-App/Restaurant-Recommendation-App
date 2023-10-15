//
//  FollowSelectionCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/15.
//

import UIKit

class FollowSelectionCell: UITableViewCell {
    
    private let profileView: ProfileView = ProfileView()
    var didTapFollowHandler: ((RecommendFollowResponse?, Bool) -> Void)?
    
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
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        profileView.followButtonSelectedHandler = { [weak self] avatar, isSelected in
            self?.didTapFollowHandler?(avatar, isSelected)
        }
    }
    
    private func resetData() {
    }
    
    // MARK: Public
    func configrue(with recommendFollow: RecommendFollowResponse) {
        profileView.updateAvatar(recommendFollow)
    }
}
