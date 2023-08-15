//
//  NicknameViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class NicknameViewController: UIViewController {
    static func instance<T: NicknameViewController>(viewMode: NicknameViewModelType) -> T {
        let vc: T = .instance(storyboardName: .nickname)
        vc.viewModel = viewMode
        return vc
    }
    
    @IBOutlet private weak var nextButton: CustomProfileButton!
    private var nextButtonOnKeyboard: CustomProfileButton = {
        let button = CustomProfileButton()
        button.setLayerCornerRadius(0.0)
        button.isHidden = true
        return button
    }()
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var duplicationCheckButton: UIButton!
    private var viewModel: NicknameViewModelType!
    private var cancellables: Set<AnyCancellable> = []
    var delegate: ProfileSetupDelegate?
    
    enum Constants {
        static let messageSuccessColor = UIColor(hexString: "3972E1")
        static let messageErrorColor = UIColor(hexString: "D82231")
        static let duplicationEnableColor = UIColor(hexString: "FFF2F4")
        static let duplicationDisableColor = UIColor.cheffiGray1
        static let buttonHeight: CGFloat = 50.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private
    private func setupViews() {
        nextButton.setTitle("다음")
        nextButton.setBackgroundColor(Constants.duplicationDisableColor)
        nextButton.didTapButton = { [weak self] in
            self?.delegate?.didTapNext()
        }
        
        titleLabel.text = "쉐피에서 사용할\n닉네임을 입력해주세요.".localized()
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.weight600.size(24)
        textField.delegate = self
        
        // messageLabel
        messageLabel.text = ""
        messageLabel.font = Fonts.suit.weight400.size(14)
        messageLabel.textColor = Constants.messageSuccessColor
        
        // duplicationCheckButton
        duplicationCheckButton.setTitleColor(.main, for: .normal)
        duplicationCheckButton.setTitleColor(.cheffiGray5, for: .disabled)
        
        // textField
        textField.layerBorderColor = .cheffiBlack
        textField.layerBorderWidth = 1.0
        textField.layerCornerRadius = 10.0
        textField.inputAccessoryView = nil
    }
    
    private func bindViewModel() {
        viewModel.isDuplicationCheckButtonEnabled
            .sink { [weak self] isEnabled in
                self?.duplicationCheckButton.isEnabled = isEnabled
                self?.duplicationCheckButton.backgroundColor = isEnabled ? Constants.duplicationEnableColor : Constants.duplicationDisableColor
            }
            .store(in: &cancellables)
        
        viewModel.message
            .assign(to: \.text, on: messageLabel)
            .store(in: &cancellables)
        
        viewModel.messageStatus
            .sink { [weak self] status in
                switch status {
                case .error:
                    self?.messageLabel.textColor = Constants.messageErrorColor
                    self?.nextButton.setBackgroundColor(.cheffiGray3)
                    self?.nextButtonOnKeyboard.setBackgroundColor(.cheffiGray3)
                    self?.textField.layerBorderColor = Constants.messageErrorColor
                case .success:
                    self?.messageLabel.textColor = Constants.messageSuccessColor
                    self?.nextButton.setBackgroundColor(.main)
                    self?.nextButtonOnKeyboard.setBackgroundColor(.main)
                    self?.textField.layerBorderColor = Constants.messageSuccessColor
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
        
        textField.textDidChangePublisher
            .sink { [weak self] newText in
                self?.viewModel.nickname.send(newText)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
    @IBAction private func duplicationCheck(_ sender: UIButton) {
        viewModel.checkNicknameDuplication()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.addSubview(nextButtonOnKeyboard)
            nextButtonOnKeyboard.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(Constants.buttonHeight)
                make.bottom.equalToSuperview().offset(-keyboardSize.height+self.bottomSafeArea)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        nextButtonOnKeyboard.removeFromSuperview()
    }
    
    @objc func didTapNextOnKeyboard() {
        self.delegate?.didTapNext()
        hideKeyboard()
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension NicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        nextButtonOnKeyboard.isHidden = !(newText.count >= 2)
        return newText.count <= viewModel.maxNicknameCount
    }
}
