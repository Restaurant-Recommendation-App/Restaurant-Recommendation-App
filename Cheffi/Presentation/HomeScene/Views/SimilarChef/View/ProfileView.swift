//
//  ProfileView.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit

class ProfileView: UIView {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layerCornerRadius = 32
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(argbHexString: "0A0A0A")
        return label
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로워 : "
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(argbHexString: "636363")
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = "#한식 #노포 #매운맛"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(argbHexString: "9E9E9E")
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("팔로우".localized(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layerCornerRadius = 10
        button.backgroundColor = UIColor(argbHexString: "D82231")
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNickname(_ nickname: String) {
        self.nicknameLabel.text = nickname
    }
    
    // MARK: - private
    private func setupViews() {
        self.addSubviews([profileImageView, nicknameLabel, followerLabel, tagLabel, followButton])
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(64)
            make.centerX.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        followerLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(followerLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        followButton.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(32)
        }
    }
}

