//
//  TasteSelectionViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class TasteSelectionViewController: UIViewController {
    static func instance<T: TasteSelectionViewController>(viewModel: TasteSelectionViewModelType) -> T {
        let vc: T = .instance(storyboardName: .tasteSelection)
        vc.viewModel = viewModel
        return vc
    }
    
    private enum Constants {
        static let maximumNumberOfSelection: Int = 5
    }
    
    @IBOutlet private weak var nextButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var tasteTagListView: ProfileTagListView!
    var delegate: ProfileSetupDelegate?
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: TasteSelectionViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.input.requestGetTags(type: .taste)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nickname = UserDefaultsManager.UserInfo.user?.nickname ?? ""
        titleLabel.text = "\(nickname) 쉐피님,\n쉐피님의 취향을 선택해주세요.".localized()
    }
    
    // MARK: - Private
    private func setupViews() {
        nextButton.setTitle("다음".localized(), for: .normal)
        nextButton.didTapButton = { [weak self] in
            self?.viewModel.input.requestPutTags()
        }
        
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.weight600.size(24)
        
        let subTitleFont = Fonts.suit.weight600.size(15)
        subTitleLabel.highlightKeyword("5가지".localized(), in: "5가지 이상 선택해주세요".localized(),
                                       defaultColor: .cheffiGray6,
                                       font: subTitleFont, keywordFont: subTitleFont)
        
        tasteTagListView.didTapTagsHandler = { [weak self] selectedTags in
            self?.viewModel.input.setSelectionTags(selectedTags)
            self?.nextButton.isEnable = selectedTags.count >= Constants.maximumNumberOfSelection
        }
    }
    
    private func bindViewModel() {
        viewModel.output.responseTags
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("---------------------------------------")
                    print(error)
                    print("---------------------------------------")
                }
            } receiveValue: { [weak self] tags in
                self?.reload(with: tags)
            }
            .store(in: &cancellables)

        viewModel.output.updateCompletionTags
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("---------------------------------------")
                    print(error)
                    print("---------------------------------------")
                }
            } receiveValue: { [weak self] tagResponse in
                self?.delegate?.didTapNext(params: [:])
            }
            .store(in: &cancellables)

    }
    
    private func reload(with tags: [Tag]) {
        tasteTagListView.setupTags(tags.map { $0 })
    }
    
    // MARK: - Public
    func setParams(_ params: [ProfilePageKey: Any]) {
        guard let foodSelectionTags = params[.profileFoodSelection] as? [Tag] else { return }
        viewModel.input.setSelectionTags(foodSelectionTags)
    }
}
