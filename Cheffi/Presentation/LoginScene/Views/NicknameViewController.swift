//
//  NicknameViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine
import SwifterSwift

class NicknameViewController: UIViewController {
    static func instance<T: NicknameViewController>(viewMode: NicknameViewModelType) -> T {
        let vc: T = .instance(storyboardName: .nickname)
        vc.viewModel = viewMode
        return vc
    }
    
    private var nextButtonOnKeyboard: CustomProfileButton = {
        let button = CustomProfileButton()
        button.setLayerCornerRadius(0.0)
        return button
    }()
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var nicknameTitleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    @IBOutlet private weak var duplicationCheckButton: UIButton!
    private var viewModel: NicknameViewModelType!
    private var cancellables: Set<AnyCancellable> = []
    private lazy var clearButton: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "icClearButton"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        view.addSubview(clearButton)
        clearButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(18)
        }
        view.snp.makeConstraints { make in
            make.width.equalTo(clearButton.snp.width).offset(12 + 18)
            make.height.equalTo(clearButton.snp.height)
        }
        return view
    }()
    var delegate: ProfileSetupDelegate?
    
    private enum Constants {
        static let messageSuccessColor = UIColor(hexString: "3972E1")!
        static let messageErrorColor = UIColor.cheffiRed
        static let messageDefaultColor = UIColor.cheffiBlack
        static let duplicationEnableColor = UIColor(hexString: "FFF2F4")!
        static let duplicationDisableColor = UIColor.cheffiGray1
        static let buttonHeight: CGFloat = 50.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        setupKeyboard()
        // show keyboard
        textField.becomeFirstResponder()
    }
    
    // MARK: - Private
    private func setupViews() {
        nextButtonOnKeyboard.didTapButton = { [weak self] in
            self?.nextView()
            self?.hideKeyboard()
        }
        
        // titleLabel
        titleLabel.text = "쉐피에서 사용할\n닉네임을 입력해주세요.".localized()
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.weight600.size(22)
        textField.delegate = self
        
        // nicknameTitleLabel
        nicknameTitleLabel.text = "닉네임".localized()
        nicknameTitleLabel.textColor = .cheffiGray8
        nicknameTitleLabel.font = Fonts.suit.weight400.size(14)
        
        // errorMessageLabel
        errorMessageLabel.text = ""
        errorMessageLabel.font = Fonts.suit.weight400.size(14)
        errorMessageLabel.textColor = Constants.messageSuccessColor
        
        // duplicationCheckButton
        duplicationCheckButton.setTitleColor(.main, for: .normal)
        duplicationCheckButton.setTitleColor(.cheffiGray5, for: .disabled)
        
        // textField
        textField.textColor = .cheffiGray8
        textField.font = Fonts.suit.weight400.size(14.0)
        textField.layerBorderColor = .cheffiBlack
        textField.layerBorderWidth = 1.0
        textField.layerCornerRadius = 10.0
        textField.inputAccessoryView = nil
        
        textField.rightView = clearButton
        clearTextField()
    }
    
    private func bindViewModel() {
        viewModel.isDuplicationCheckButtonEnabled
            .sink { [weak self] isEnabled in
                self?.duplicationCheckButton.isEnabled = isEnabled
                self?.duplicationCheckButton.backgroundColor = isEnabled ? Constants.duplicationEnableColor : Constants.duplicationDisableColor
            }
            .store(in: &cancellables)
        
        viewModel.message
            .assign(to: \.text, on: errorMessageLabel)
            .store(in: &cancellables)
        
        viewModel.messageStatus
            .sink { [weak self] status in
                guard let self = self else { return }
                        
                let messageStatusDict: [NicknameMessageStatus: (textColor: UIColor, backgroundColor: UIColor, borderColor: UIColor, isEnable: Bool)] = [
                    .numberOfCharError: (Constants.messageErrorColor, .cheffiGray3, Constants.messageDefaultColor, false),
                    .duplicateError: (Constants.messageErrorColor, .cheffiGray3, Constants.messageErrorColor, false),
                    .success: (Constants.messageSuccessColor, .main, Constants.messageSuccessColor, true),
                    .none: (Constants.messageDefaultColor, .cheffiGray1, Constants.messageDefaultColor, false)
                ]

                if let messageStatus = messageStatusDict[status] {
                    self.errorMessageLabel.textColor = messageStatus.textColor
                    self.nextButtonOnKeyboard.setBackgroundColor(messageStatus.backgroundColor)
                    self.textField.layerBorderColor = messageStatus.borderColor
                    self.nextButtonOnKeyboard.isEnable = messageStatus.isEnable
                }
            }
            .store(in: &cancellables)
        
        textField.textDidChangePublisher
            .sink { [weak self] newText in
                self?.viewModel.nickname.send(newText)
                self?.textField.rightViewMode = (self?.textField.text?.isEmpty == false) ? .always : .never
            }
            .store(in: &cancellables)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func saveNicknameToLocalDB(name: String) {
        UserDefaultsManager.AuthInfo.user = User(email: "", name: name, provider: .apple, adAgreed: true, analysisAgreed: true)
    }
    
    private func nextView() {
        if let name = textField.text?.trimmed {
            saveNicknameToLocalDB(name: name)
        }
        delegate?.didTapNext()
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
    @IBAction private func duplicationCheck(_ sender: UIButton) {
        viewModel.checkNicknameDuplication()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            nextButtonOnKeyboard.removeFromSuperview()
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
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func clearTextField() {
        viewModel.nickname.send("")
        textField.text = ""
        textField.rightViewMode = .never
    }
}

// MARK: - UITextFieldDelegate
extension NicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if newText.count > viewModel.maxNicknameCount {
            viewModel.showMessageForExceedingMaxCount()
            return false
        }
        
        return true
    }
}
