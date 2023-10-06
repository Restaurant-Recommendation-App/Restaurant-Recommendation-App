//
//  ProfileImageSelectButton.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/09/23.
//

import UIKit

enum ProfileImageSelectType: Int {
    case camera = 0
    case album
    case defaultImage
    
    var title: String {
        switch self {
        case .camera: return "직접 찍기".localized()
        case .album: return "앨범 선택".localized()
        case .defaultImage: return "기본 이미지로 변경".localized()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .camera: return UIImage(named: "icProfileSelectPhoto")
        case .album: return UIImage(named: "icProfileSelectAlbum")
        case .defaultImage: return UIImage(named: "icProfileSelectDefaultImage")
        }
    }
}

class ProfileImageSelectButton: BaseView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        titleLabel.font = Fonts.suit.weight400.size(16)
        titleLabel.textColor = .cheffiBlack
    }
    
    // MARK: - Public
    func setContents(_ type: ProfileImageSelectType) {
        titleLabel.text = type.title
        imageView.image = type.image
    }
}
