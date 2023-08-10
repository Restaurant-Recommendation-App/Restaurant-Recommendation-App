//
//  CheffiRecommendationCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/18.
//

import UIKit
import Combine

final class CheffiRecommendationCell: UITableViewCell {
    
    typealias ViewModel = CheffiRecommendationViewModel
    
    var cancellables = Set<AnyCancellable>()
    
    private let initialize = PassthroughSubject<Void, Never>()
    private var scrolledToBottom: AnyPublisher<Void, Never> = Empty().eraseToAnyPublisher()
    private let reloadedContents = PassthroughSubject<Void, Never>()
    
    var reload = false
    
    enum Constants {
        static let cellInset: CGFloat = 16.0
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "쉐피들의 인정 맛집"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .cheffiBlack
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "‘맛있어요’ 투표율이 높아요!"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .cheffiGray7
        label.numberOfLines = 2
        return label
    }()
    
    private let showAllContentsButton: ShowAllContentsButton = {
        let button = ShowAllContentsButton()
        button.setTItle("더보기".localized(), direction: .down)
        return button
    }()
    
    private let categoryTabView = CategoryTabView()
    
    private let cheffiRecommendationCatogoryPageView = CheffiRecommendationCategoryPageView()
    
    private var updateContentHeight: ((CGSize) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setUp()
        categoryTabView.setUpTags(tags: ["한식", "양식", "중식", "일식", "퓨전", "샐러드"])
        cheffiRecommendationCatogoryPageView.categoryPageViewDelegate = categoryTabView
        categoryTabView.delegate = cheffiRecommendationCatogoryPageView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 48, left: 0, bottom: 16, right: 0)
        )
    }
    private func setUp() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.cellInset)
        }

        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(Constants.cellInset)
        }

        contentView.addSubview(categoryTabView)
        categoryTabView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }

        contentView.addSubview(cheffiRecommendationCatogoryPageView)
        cheffiRecommendationCatogoryPageView.snp.makeConstraints {
            $0.top.equalTo(categoryTabView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(550)
//            $0.bottom.equalToSuperview()
        }

        contentView.addSubview(showAllContentsButton)
        showAllContentsButton.snp.makeConstraints {
            $0.top.equalTo(cheffiRecommendationCatogoryPageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(Constants.cellInset)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        // Action
        showAllContentsButton.didTapViewAllHandler = { [weak self] in
        }
    }
    
    func configure(viewModel: ViewModel, scrolledToBottom: AnyPublisher<Void, Never>, updateContentHeight: @escaping (CGSize) -> Void) {
        self.scrolledToBottom = scrolledToBottom
        self.updateContentHeight = updateContentHeight
        bind(to: viewModel)
        initialize.send(())
        
        if reload {
            reloadedContents.send(())
            reload = false
        }
    }
}

extension CheffiRecommendationCell: Bindable {
    
    func bind(to viewModel: ViewModel) {
        cancellables.forEach {
            $0.cancel()
        }
        cancellables =  Set<AnyCancellable>()
        
        let input = ViewModel.Input(
            initialize: initialize,
            reloadedContents: reloadedContents.eraseToAnyPublisher(),
            viewMoreButtonTapped: showAllContentsButton.controlPublisher(for: .touchUpInside)
                .map { _ -> Void in () }
                .eraseToAnyPublisher(),
            scrolledToBottom: scrolledToBottom,
            tappedCategory: categoryTabView.tappedCategory.eraseToAnyPublisher(),
            scrolledCategory: cheffiRecommendationCatogoryPageView.scrolledCategory.eraseToAnyPublisher()
            
        )
        let output = viewModel.transform(input: input)
        
        output.categories
            .filter { _ in !viewModel.initialized }
            .sink { categories in
                self.categoryTabView.setUpTags(tags: categories)
            }.store(in: &cancellables)
        
        output.restaurantContentsViewModels
            .sink { (viewModels, updateContentHeight) in
                if updateContentHeight {
                    CheffiRecommendationCategoryPageView.updatedContentHeight = false
                }
                
                self.cheffiRecommendationCatogoryPageView.configure(
                    viewModels: viewModels,
                    currentCategoryPageIndex: viewModel.currentCategoryIndex,
                    updateContentHeight: self.updateContentHeight
                )
            }.store(in: &cancellables)
        
        output.hideMoreViewButton
            .sink { _ in
                self.showAllContentsButton.isHidden = true
            }.store(in: &cancellables)
    }
}
