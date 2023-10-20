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
    
    @IBOutlet private weak var selectProfileImageButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var laterButton: UIButton!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileChangeStackView: UIStackView!
    private var viewModel: ProfilePhotoViewModelType!
    private var cancellables: Set<AnyCancellable> = []
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nickname = UserDefaultsManager.UserInfo.user?.nickname ?? ""
        titleLabel.text = "\(nickname) 쉐피님,\n프로필 사진을 설정해주세요.".localized()
    }
    
    // MARK: - Private
    private func setupViews() {
        // titleLabel
        titleLabel.textColor = .cheffiBlack
        titleLabel.font = Fonts.suit.weight600.size(22)
        
        // subTitleLabel
        subTitleLabel.text = "다른 사용자가 나를 알 수 있게 프로필을 만들어보세요".localized()
        subTitleLabel.textColor = .cheffiGray6
        subTitleLabel.font = Fonts.suit.weight600.size(15)
        
        // select profile image button
        selectProfileImageButton.isEnable = true
        selectProfileImageButton.setTitle("프로필 이미지 선택".localized(), for: .normal)
        selectProfileImageButton.setBackgroundColor(.main)
        selectProfileImageButton.didTapButton = { [weak self] in
            // show action sheet
            self?.showProfileImageSelect(types: [.camera, .album])
        }
        
        let titleString = "나중에 하기".localized()
        let attributedString = NSMutableAttributedString(string: titleString)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: titleString.count))
        laterButton.setAttributedTitle(attributedString, for: .normal)
        laterButton.titleLabel?.font = Fonts.suit.weight600.size(16)
        laterButton.setTitleColor(.cheffiGray4, for: .normal)
        
        // Profile stackview
        profileChangeStackView.isHidden = true
    }
    
    private func bindViewModel() {
        viewModel.output.responsePostPhotos
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    // TODO: - 로딩 화면 종료 후 에러 화면
                    print("---------------------------------------")
                    print("profile upload error")
                    print("---------------------------------------")
                }
            } receiveValue: { [weak self] profileUrl in
                // TODO: - 로딩 화면 종료
                print("---------------------------------------")
                print("profile url")
                print(profileUrl ?? "")
                print("---------------------------------------")
                self?.delegate?.didTapNext(params: [:])
            }
            .store(in: &cancellables)
    }
    
    private func showProfileImageSelect(types: [ProfileImageSelectType]) {
        viewModel.output.showProfileImageSelect(types) { [weak self] selectType in
            self?.presentedViewController?.dismiss(animated: false)
            switch selectType {
            case .camera:
                self?.showCamera()
            case .album:
                self?.showPhotoAlbum()
            case .defaultImage:
                self?.setProfileImage(imageData: nil)
            }
        }
    }
    
    private func setProfileImage(imageData: Data?) {
        var jpegData: Data? = nil
        if let data = imageData, let image = UIImage(data: data) {
            jpegData = image.jpegData(compressionQuality: 0.1)
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(named: "icPlaceholder")
        }
        
        viewModel.input.setImageData(imageData: jpegData)
    }
    
    private func showProfileChangeView() {
        guard profileChangeStackView.arrangedSubviews.isEmpty else { return }
        let profileChangeButton = CustomProfileButton()
        profileChangeButton.isEnable = true
        profileChangeButton.setTitle("프로필 이미지 변경".localized(), for: .normal)
        profileChangeButton.setTitleColor(.mainCTA, for: .normal)
        profileChangeButton.setBackgroundColor(.white)
        profileChangeButton.setLayerCornerRadius(10)
        profileChangeButton.setTitleFont(font: Fonts.suit.weight600.size(16))
        profileChangeButton.setLayerBorderColor(.mainCTA)
        profileChangeButton.setLayerBorderWidth(1)
        profileChangeButton.didTapButton = { [weak self] in
            self?.showProfileImageSelect(types: [.camera, .album, .defaultImage])
        }
        let nextButton = CustomProfileButton()
        nextButton.isEnable = true
        nextButton.setTitle("다음".localized(), for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setBackgroundColor(.mainCTA)
        nextButton.setLayerCornerRadius(10)
        nextButton.setTitleFont(font: Fonts.suit.weight600.size(16))
        nextButton.didTapButton = { [weak self] in
            self?.viewModel.input.postPhostosDidTap()
        }
        
        profileChangeStackView.isHidden = false
        profileChangeStackView.addArrangedSubview(profileChangeButton)
        profileChangeStackView.addArrangedSubview(nextButton)
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
    private func showCamera() {
        viewModel.output.showCamera(false) { [weak self] captureImageData in
#if DEBUG
            print("capture image data- \(captureImageData)")
#endif
            self?.handlePhotoCropAction(captureImageData: captureImageData) { [weak self] cropImageData in
                DispatchQueue.main.async {
                    self?.setProfileImage(imageData: cropImageData)
                    self?.showProfileChangeView()
                }
            }
        }
    }
    
    private func handlePhotoCropAction(captureImageData: Data?, completion: @escaping (Data?) -> Void) {
        viewModel.output.showPhotoCrop(captureImageData) { cropImageData in
            completion(cropImageData)
        }
    }
    
    private func showPhotoAlbum() {
        viewModel.output.showPhotoAlbum { [weak self] cropImageData in
#if DEBUG
            print("crop image data - \(cropImageData)")
#endif
            DispatchQueue.main.async {
                self?.setProfileImage(imageData: cropImageData)
                self?.showProfileChangeView()
            }
        }
    }
    
    @IBAction private func didTapLater(_ sender: UIButton) {
        delegate?.didTapNext(params: [:])
    }
}
