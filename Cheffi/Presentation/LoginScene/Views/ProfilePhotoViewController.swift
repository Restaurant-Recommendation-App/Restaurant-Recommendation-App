//
//  ProfilePhotoViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class ProfilePhotoViewController: UIViewController {
    static func instance<T: ProfilePhotoViewController>(viewModel: ProfilePhotoViewModelType) -> T {
        let vc: T = .instance(storyboardName: .profilePhoto)
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet private weak var registerProfileButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var laterButton: UIButton!
    @IBOutlet private weak var profileImageView: UIImageView!
    private var viewModel: ProfilePhotoViewModelType!
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        registerProfileButton.setTitle("프로필 등록하기".localized())
        registerProfileButton.setBaackgroundColor(.main)
        registerProfileButton.didTapButton = { [weak self] in
#if DEBUG
            print("프로필 등록")
#endif
            self?.delegate?.didTapNext()
        }
        
        let nickname = "김맛집"
        titleLabel.text = "\(nickname) 쉐피님,\n프로필 사진을 설정해주세요.".localized()
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.weight600.size(24)
        
        subTitleLabel.text = "다른 사용자가 나를 알 수 있게 프로필을 만들어보세요".localized()
        subTitleLabel.textColor = .cheffiGray6
        subTitleLabel.font = Fonts.suit.weight600.size(15)
        
        let titleString = "나중에 하기".localized()
        let attributedString = NSMutableAttributedString(string: titleString)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: titleString.count))
        laterButton.setAttributedTitle(attributedString, for: .normal)
        laterButton.titleLabel?.font = Fonts.suit.weight600.size(16)
        laterButton.setTitleColor(.cheffiGray4, for: .normal)
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
    @IBAction private func didTapCamera(_ sender: UIButton) {
        viewModel.showPhotoAlbum { [weak self] cropImageData in
#if DEBUG
            print("여기로")
#endif
            guard let data = cropImageData else { return }
            DispatchQueue.main.async {
                self?.profileImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction private func didTapLater(_ sender: UIButton) {
        delegate?.didTapNext()
    }
}
