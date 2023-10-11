//
//  AllCheffiContentsViewController.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/09.
//

import UIKit
import Combine

final class AllCheffiContentsViewController: UIViewController {
    
    private enum Constants {
        static let widthInset = 16
    }
    
    typealias ViewModel = AllCheffiContentsViewModel
    
    var viewModel: ViewModel!
    var cancellables = Set<AnyCancellable>()
    let initialize = PassthroughSubject<Void, Never>()
    
    
    private let allContentsViewTopBar = AllCheffiContentsVCTopBar()
    
    private let subtitleTimerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cheffiBlack
        return label
    }()
    
    private let subtitleLabel01: UILabel = {
        let label = UILabel()
        label.textColor = .cheffiBlack
        label.text = "초 뒤에"
        label.font = Fonts.suit.weight400.size(18)
        return label
    }()
    
    private let subtitleLabel02: UILabel = {
        let label = UILabel()
        label.textColor = .cheffiBlack
        label.text = "인기 급등 맛집이 변경돼요."
        label.font = Fonts.suit.weight400.size(18)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cheffiBlack
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var exclamationButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "icExclamationMark.circle")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tappedExclamation), for: .touchUpInside)
        return button
    }()
    
    private var oneColumnButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cheffiBlack
        
        return button
    }()
    
    private var twoColumnButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cheffiRed
        
        return button
    }()
    
    private let contentsView = CheffiRecommendationContensView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setTimerString(timerString: "00:00:00")
        configure(viewModel: viewModel)
        contentsView.isScrollEnabled = true
    }
    
    private func setUp() {
        view.addSubview(allContentsViewTopBar)
        allContentsViewTopBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.leading.trailing.equalToSuperview().inset(Constants.widthInset)
            $0.height.equalTo(44)
        }
        
        view.addSubview(subtitleTimerLabel)
        subtitleTimerLabel.snp.makeConstraints {
            $0.top.equalTo(allContentsViewTopBar.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(Constants.widthInset)
            $0.width.equalTo(110)
        }
        
        view.addSubview(subtitleLabel01)
        subtitleLabel01.snp.makeConstraints {
            $0.top.equalTo(subtitleTimerLabel.snp.top)
            $0.leading.equalTo(subtitleTimerLabel.snp.trailing)
        }
        
        view.addSubview(subtitleLabel02)
        subtitleLabel02.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel01.snp.bottom)
            $0.leading.equalToSuperview().inset(Constants.widthInset)
        }
        
        view.addSubview(exclamationButton)
        exclamationButton.snp.makeConstraints {
            $0.leading.equalTo(subtitleLabel02.snp.trailing).offset(4)
            $0.bottom.equalTo(subtitleLabel02)
        }
        
        view.addSubview(twoColumnButton)
        twoColumnButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel01.snp.bottom)
            $0.trailing.equalToSuperview().inset(Constants.widthInset)
            $0.width.height.equalTo(24)
        }
        
        view.addSubview(oneColumnButton)
        oneColumnButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel01.snp.bottom)
            $0.trailing.equalTo(twoColumnButton.snp.leading).offset(-12)
            $0.width.height.equalTo(24)
        }
        
        view.addSubview(contentsView)
        contentsView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel01.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(Constants.widthInset)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setTimerString(timerString: String) {
        subtitleTimerLabel.attributedText = getTimerAttributedString(timerString: timerString)
    }
    
    private func getTimerAttributedString(timerString: String) -> NSAttributedString {
        
        let icClockAttachment = NSTextAttachment()
        let icClockImg = UIImage(named: "icClock")
        icClockAttachment.image = icClockImg
        icClockAttachment.bounds = CGRect(x: 0, y: -2, width: icClockImg!.size.width, height: icClockImg!.size.height)
        let icClockString = NSAttributedString(attachment: icClockAttachment)
        
        let str1 = "  \(timerString)"
        let color1 = UIColor.main
        let font1 = Fonts.suit.weight800.size(18)
        
        let combination = NSMutableAttributedString()
        
        let attr1 = [NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font: font1]
        let part1 = NSMutableAttributedString(string: str1, attributes: attr1 as [NSAttributedString.Key : Any])
        
        combination.append(icClockString)
        combination.append(part1)
        
        return combination
    }
    
    @objc private func tappedExclamation() {
        print("tappedExclamation")
    }
    
    private func configure(viewModel: ViewModel) {
        bind(to: viewModel)
        initialize.send(())
    }
}

extension AllCheffiContentsViewController: Bindable {
    func bind(to viewModel: ViewModel) {
        cancellables.forEach {
            $0.cancel()
        }
        cancellables = Set<AnyCancellable>()
        
        let input = ViewModel.Input(initialize: initialize.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.contentsViewModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModel in
                self?.contentsView.configure(viewModel: viewModel)
            }.store(in: &cancellables)
        
        output.timeLockType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timerString in
                self?.setTimerString(timerString: timerString)
            }.store(in: &cancellables)
        
        oneColumnButton.controlPublisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.contentsView.setColumnStyle(columnStyle: .one)
            }.store(in: &cancellables)
        
        twoColumnButton.controlPublisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.contentsView.setColumnStyle(columnStyle: .two)
            }.store(in: &cancellables)
        
        allContentsViewTopBar.backButtonTapped
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellables)
    }
}
