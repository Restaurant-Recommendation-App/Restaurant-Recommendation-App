//
//  SNSLoginViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit
import Combine

class SNSLoginViewController: UIViewController {
    static func instance<T: SNSLoginViewController>(viewModel: SNSLoginViewModelType) -> T {
        let vc: T = .instance(storyboardName: .SNSLogin)
        vc.viewModel = viewModel
        return vc
    }
    
    private var viewModel: SNSLoginViewModelType!
    private var cancellables: [AnyCancellable] = []
    @IBOutlet private weak var kakaoLoginButton: UIButton!
    @IBOutlet private weak var appleLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    deinit {
#if DEBUG
        print("SNSLoginViewController deinitialized")
#endif
    }
    
    // MARK: - Private
    private func setupViews() {
        let kakaoConfig = createButtonConfig(
            imageName: "icKakaoLogo",
            backgroundColor: UIColor(hexString: "FFE500")!,
            title: "카카오톡 로그인".localized()
        )
        configureButton(kakaoLoginButton, with: kakaoConfig, cornerRadius: 10.0)
        
        let appleConfig = createButtonConfig(
            imageName: "icAppleLogo",
            backgroundColor: .white,
            title: "Apple로 로그인".localized()
        )
        configureButton(appleLoginButton, with: appleConfig, cornerRadius: 10.0)
    }
    
    private func bindViewModel() {
        viewModel.output.isAppleLoginSuccess
            .sink { [weak self] isSuccess in
                self?.loginSuccess(nil)
            }
            .store(in: &cancellables)
        
        viewModel.output.isKakaoLoginSuccess
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    // TODO: - 로딩 화면 종료 후 에러 화면
                    self?.showError(error)
                }
            }, receiveValue: { [weak self] user in
                // TODO: - 로딩 화면 종료
                self?.loginSuccess(user)
            })
            .store(in: &cancellables)
    }
    
    private func createButtonConfig(imageName: String, backgroundColor: UIColor, title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(named: imageName)
        config.baseBackgroundColor = backgroundColor
        config.imagePadding = 10
        
        let attributedContainer = AttributeContainer(
            [NSAttributedString.Key.font: Fonts.suit.weight500.size(16.0),
             NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        config.attributedTitle = AttributedString(title, attributes: attributedContainer)
        
        return config
    }

    private func configureButton(_ button: UIButton, with config: UIButton.Configuration, cornerRadius: CGFloat) {
        button.layerCornerRadius = cornerRadius
        button.configuration = config
    }
    
    private func showError(_ error: DataTransferError) {
        showAlert(title: "ERROR", message: error.localizedDescription)
    }
    
    private func loginSuccess(_ user: User?) {
        if let userData = user {
            UserDefaultsManager.AuthInfo.user = userData
            if userData.isNewUser == false {
                self.dismissOne(amimated: true)
            } else {
                viewModel.output.showProfileSetup()
            }
        }
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @IBAction private func didTapClose(_ sender: UIButton) {
        self.dismissOne(amimated: true)
    }
    
    @IBAction private func didTapKakaoLogin(_ sender: UIButton) {
        viewModel.input.kakaoLoginDidTap()
    }
    
    @IBAction private func didTapAppleLogin(_ sender: UIButton) {
        viewModel.input.appleLoginDidTap()
    }
}
