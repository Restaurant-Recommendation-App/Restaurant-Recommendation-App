//
//  ProfileView.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit
import Kingfisher

class ProfileView: UIView {
    var didTapFollowAvatar: ((RecommendFollowResponse?, Bool) -> Void)?
    var didTapFollowWriterInfo: ((ReviewWriterInfoDTO?, Bool) -> Void)?
    private var avatar: RecommendFollowResponse? = nil
    private var writerInfo: ReviewWriterInfoDTO? = nil
    
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
        label.font = Fonts.suit.weight600.size(16.0)
        label.textColor = UIColor(argbHexString: "2F2F2F")
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = Fonts.suit.weight400.size(12.0)
        label.textColor = UIColor(argbHexString: "5A5A5A")
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("팔로우".localized(), for: .normal)
        button.setTitle("팔로잉".localized(), for: .selected)
        button.setTitleColor(.cheffiWhite, for: .normal)
        button.setTitleColor(.cheffiGray9, for: .selected)
        button.titleLabel?.font = Fonts.suit.weight700.size(12.0)
        button.layerCornerRadius = 8.0
        button.layerBorderWidth = 1.0
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
    
    func updateAvatar(_ avatar: RecommendFollowResponse) {
        self.avatar = avatar
        self.nicknameLabel.text = avatar.nickname
        self.profileImageView.kf.setImage(with: URL(string: avatar.pictureUrl))
        let tagNames = avatar.tags.map({ $0.name })
        self.tagLabel.text = "#" + tagNames.joined(separator: " #")
    }
    
    func updateWriter(_ writerInfo: ReviewWriterInfoDTO) {
        self.writerInfo = writerInfo
        self.nicknameLabel.text = writerInfo.name
        self.profileImageView.kf.setImage(with: URL(string: writerInfo.photoUrl))
        self.tagLabel.text = writerInfo.introduction
    }
    
    // MARK: - private
    private func setupViews() {
        self.addSubviews([profileImageView, nicknameLabel, tagLabel, followButton])
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.width.equalTo(64)
            make.centerY.equalToSuperview()
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
            make.width.equalTo(70)
            make.height.equalTo(28)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func followButtonTapped() {
        followButton.isSelected.toggle()
        updateFollowButtonAppearance()
        didTapFollowAvatar?(avatar, followButton.isSelected)
        didTapFollowWriterInfo?(writerInfo, followButton.isSelected)
    }
    
    private func updateFollowButtonAppearance() {
        if followButton.isSelected {
            followButton.layerBorderColor = UIColor(hexString: "E2E2E2")
            followButton.backgroundColor = .cheffiWhite
        } else {
            followButton.layerBorderColor = .cheffiWhite
            followButton.backgroundColor = .cheffiGray9
        }
    }
}
