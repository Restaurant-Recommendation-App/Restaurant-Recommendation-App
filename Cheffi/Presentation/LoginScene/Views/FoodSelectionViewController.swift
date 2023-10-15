//
//  FoodSelectionViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class FoodSelectionViewController: UIViewController {
    static func instance<T: FoodSelectionViewController>(viewModel: FoodSelectionViewModelType) -> T {
        let vc: T = .instance(storyboardName: .foodSelection)
        vc.viewModel = viewModel
        return vc
    }
    
    private enum Constants {
        static let maximumNumberOfSelection: Int = 3
    }
    
    @IBOutlet private weak var nextButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var foodTagListView: ProfileTagListView!
    var delegate: ProfileSetupDelegate?
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: FoodSelectionViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.input.requestGetTags(type: .food)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nickname = UserDefaultsManager.AuthInfo.user?.nickname ?? ""
        titleLabel.text = "\(nickname) 쉐피님,\n좋아하는 음식을 선택해주세요.".localized()
    }
    
    // MARK: - Private
    private func setupViews() {
        nextButton.setTitle("다음".localized(), for: .normal)
        nextButton.didTapButton = { [weak self] in
            let selectionTags = self?.viewModel.output.selectionTags ?? []
            self?.delegate?.didTapNext(params: [.profileFoodSelection: selectionTags])
        }
        
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.weight600.size(24)
        
        let subTitleFont = Fonts.suit.weight600.size(15)
        subTitleLabel.highlightKeyword("3가지".localized(), in: "3가지 이상 선택해주세요".localized(),
                                       defaultColor: .cheffiGray6, font: subTitleFont, keywordFont: subTitleFont)
        
        foodTagListView.didTapTagsHandler = { [weak self] selectedTags in
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

    }
    
    private func reload(with tags: [Tag]) {
        foodTagListView.setupTags(tags.map { $0 })
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
}
