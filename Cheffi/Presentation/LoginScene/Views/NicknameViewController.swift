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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    // MARK: - Private
    private func setupViews() {
        nextButton.setTitle("다음")
        nextButton.setBaackgroundColor(.main)
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
                case .success:
                    self?.messageLabel.textColor = Constants.messageSuccessColor
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
}

// MARK: - UITextFieldDelegate
extension NicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= viewModel.maxNicknameCount
    }
}
