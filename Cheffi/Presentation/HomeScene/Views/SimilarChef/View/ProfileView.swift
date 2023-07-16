//
//  ProfileView.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit

class ProfileView: UIView {
    var followButtonSelectedHandler: ((Bool) -> Void)?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(hexString: "EAEAEA")
        imageView.layerCornerRadius = 8
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(argbHexString: "2F2F2F")
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = "#한식 #노포 #아이사음식 #매운맛 #웨이팅 짧은 #매운맛 #웨이팅 #한식 #노포 #아이사음식 #매운맛 #웨이팅 짧은 #매운맛 #웨이팅"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(argbHexString: "5A5A5A")
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("팔로우".localized(), for: .normal)
        button.setTitle("팔로잉".localized(), for: .selected)
        button.setTitleColor(UIColor(hexString: "D82231"), for: .normal)
        button.setTitleColor(UIColor(hexString: "0A0A0A"), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.layerCornerRadius = 8.0
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.updateFollowButtonAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNickname(_ nickname: String) {
        self.nicknameLabel.text = nickname
    }
    
    // MARK: - private
    private func setupViews() {
        self.addSubviews([profileImageView, nicknameLabel, tagLabel, followButton])
        profileImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(64)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalTo(followButton.snp.leading).offset(-32)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.trailing.equalTo(nicknameLabel.snp.trailing)
        }
        
        followButton.snp.makeConstraints { make in
            make.width.equalTo(70.0)
            make.height.equalTo(28)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func followButtonTapped() {
        followButton.isSelected.toggle()
        updateFollowButtonAppearance()
        followButtonSelectedHandler?(followButton.isSelected)
    }
    
    private func updateFollowButtonAppearance() {
        if followButton.isSelected {
            followButton.backgroundColor = UIColor(hexString: "EAEAEA")
        } else {
            followButton.backgroundColor = UIColor(hexString: "FFE5E8")
        }
    }
}

