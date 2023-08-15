//
//  FollowSelectionCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/15.
//

import UIKit

class FollowSelectionCell: UITableViewCell {
    
    private let profileView: ProfileView = ProfileView()
    
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
    }
    
    private func resetData() {
    }
    
    // MARK: Public
    func configrue(with nickname: String) {
        profileView.setNickname(nickname)
    }
}
