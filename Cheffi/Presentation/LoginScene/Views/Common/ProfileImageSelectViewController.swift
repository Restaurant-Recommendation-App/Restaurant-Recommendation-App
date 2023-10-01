//
//  ProfileImageSelectViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/09/23.
//

import UIKit

class ProfileImageSelectViewController: UIViewController {
    static func instance<T: ProfileImageSelectViewController>(selectTypes: [ProfileImageSelectType], selectCompletion: ((ProfileImageSelectType) -> Void)?) -> T {
        let vc: T = .instance(storyboardName: .profileImageSelect)
        vc.selectTypes = selectTypes
        vc.selectCompletion = selectCompletion
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
    
    enum Constants {
        static let selectButtonHeight: CGFloat = 54.0
    }
    
    @IBOutlet private weak var closeButton: UIButton!
    private var selectCompletion: ((ProfileImageSelectType) -> Void)?
    private var selectTypes: [ProfileImageSelectType] = []
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.backgroundColor = .white
        stack.layerCornerRadius = 10
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    deinit {
#if DEBUG
        print("ProfileImageSelectViewController deinitialized")
#endif
    }
    
    // MARK: - Private
    private func setupViews() {
        self.view.addSubview(stackView)
        let stackViewHeight: CGFloat = (CGFloat(selectTypes.count) * Constants.selectButtonHeight) + CGFloat(selectTypes.count * 1)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(stackViewHeight)
            make.bottom.equalTo(closeButton.snp.top).offset(-10)
        }
        
        addSelectButton(selectTypes)
        
        // close button
        closeButton.setTitle("취소".localized(), for: .normal)
        closeButton.titleLabel?.font = Fonts.suit.weight600.size(16)
        closeButton.backgroundColor = .white
        closeButton.setTitleColor(.cheffiRed, for: .normal)
        closeButton.layerCornerRadius = 10
    }
    
    private func addSelectButton(_ types: [ProfileImageSelectType]) {
        for (index, value) in types.enumerated() {
            let button = ProfileImageSelectButton()
            button.setContents(value)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSelectButton))
            button.tag = index
            button.addGestureRecognizer(tapGesture)
            stackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(Constants.selectButtonHeight)
            }
            
            if index != types.count {
                let lineView = makeLineView()
                stackView.addArrangedSubview(lineView)
                lineView.snp.makeConstraints { make in
                    make.height.equalTo(1)
                }
            }
        }
    }
    
    private func makeLineView() -> UIView {
        let view: UIView = UIView()
        view.backgroundColor = .cheffiGray1
        return view
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @objc private func didTapSelectButton(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag, let selectType = ProfileImageSelectType(rawValue: tag) else { return }
        selectCompletion?(selectType)
    }
    
    @IBAction private func didTapClose(_ sender: UIButton) {
        self.dismissOne(amimated: true)
    }
}
