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
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var selectProfileImageButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var laterButton: UIButton!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var photoButton: UIButton!
    @IBOutlet private weak var introTextCountLabel: UILabel!
    @IBOutlet private weak var introTextView: UITextView!
    
    private var viewModel: ProfilePhotoViewModelType!
    private var cancellables: Set<AnyCancellable> = []
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        scrollView.isScrollEnabled = false
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
        subTitleLabel.text = "다른 사용자가 나를 알 수 있게 나타내 보세요.".localized()
        subTitleLabel.textColor = .cheffiGray6
        subTitleLabel.font = Fonts.suit.weight600.size(15)
        
        // introduction
        let nickname = UserDefaultsManager.UserInfo.user?.nickname ?? ""
        introTextView.text = "\(nickname) 쉐피 입니다 :)"
        introTextView.textAlignment = .left
        introTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        introTextCountLabel.text = "\(introTextView.text?.count ?? 0)/50"
        
        // select profile image button
        selectProfileImageButton.isEnable = true
        selectProfileImageButton.setTitle("다음".localized(), for: .normal)
        selectProfileImageButton.setBackgroundColor(.main)
        selectProfileImageButton.didTapButton = { [weak self] in
            self?.viewModel.input.postPhostosDidTap()
        }
        
        let titleString = "건너뛰기".localized()
        let attributedString = NSMutableAttributedString(string: titleString)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: titleString.count))
        laterButton.setAttributedTitle(attributedString, for: .normal)
        laterButton.titleLabel?.font = Fonts.suit.weight600.size(16)
        laterButton.setTitleColor(.cheffiGray4, for: .normal)
        
        photoButton.addShadow(ofColor: .black.withAlphaComponent(0.2))
        photoButton.imageView?.masksToBounds = true
        
        let defaultImageData = UIImage(named: "icPlaceholder")!.jpegData(compressionQuality: 0.1)!
        self.viewModel.input.setImageData(imageData: defaultImageData)
        self.viewModel.input.setPlaceHolder(introTextView.text)
        self.viewModel.input.setIntroduction(introTextView.text)
    }
    
    private func bindViewModel() {
        viewModel.output.responsePostPhotos
            .sink { completion in
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
        
        introTextView.textPublisher()
            .receive(on: RunLoop.main)
            .sink { text in
                if text.count <= 50 {
                    self.introTextCountLabel.text = "\(text.count)/50"
                } else {
                    self.introTextView.text = String(text.prefix(50))
                }
                
                self.viewModel.input.setIntroduction(self.introTextView.text)
            }.store(in: &cancellables)
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
    }
    
    // MAKR: - Actions
    private func showCamera() {
        viewModel.output.showCamera(false) { [weak self] captureImageData in
#if DEBUG
            print("capture image data- \(captureImageData)")
#endif
            self?.handlePhotoCropAction(captureImageData: captureImageData) { [weak self] cropImageData in
                DispatchQueue.main.async {
                    self?.setProfileImage(imageData: cropImageData)
                    self?.viewModel.isPhotoSelected = true
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
        viewModel.output.showPhotoAlbum { [weak self] cropImageDatas in
            guard let cropImageData = cropImageDatas[safe: 0] else { return }
#if DEBUG
            print("crop image data - \(cropImageData)")
#endif
            DispatchQueue.main.async {
                self?.setProfileImage(imageData: cropImageData)
                self?.viewModel.isPhotoSelected = true
            }
        }
    }
    
    @IBAction private func didTapPhoto(_ sender: UIButton) {
        if viewModel.isPhotoSelected {
            showProfileImageSelect(types: [.camera, .album, .defaultImage])
        } else {
            showProfileImageSelect(types: [.camera, .album])
        }
    }
    
    @IBAction private func didTapLater(_ sender: UIButton) {
        delegate?.didTapNext(params: [:])
    }
}

// MARK: - KeyboardNotification
extension ProfilePhotoViewController {
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] (keyboardFrame) in
            guard let self else { return }

            self.scrollView.contentSize = CGSize(width: self.view.width, height: self.view.height + keyboardFrame.height)
            self.scrollView.setContentOffset(CGPoint(x: 0, y: keyboardFrame.height - 40), animated: false)
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] (_) in
            guard let self else { return }
            
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
    @objc
    private func handleTapGesture() {
        introTextView.endEditing(true)
    }
}
