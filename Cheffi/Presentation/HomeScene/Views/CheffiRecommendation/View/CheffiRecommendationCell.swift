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
        
    enum Constants {
        static let cellInset: CGFloat = 16.0
        static let otherContentsSize: CGFloat = 270
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "쉐피들의 인정 맛집"
        label.font = Fonts.suit.weight700.size(20)
        label.textColor = .cheffiBlack
        return label
    }()
        
    private let exclamationButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "icExclamationMark.circle")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let categoryTabView = CategoryTabView()
    
    private let cheffiRecommendationCatogoryPageView = CheffiRecommendationCategoryPageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setUp()
        cheffiRecommendationCatogoryPageView.categoryPageViewDelegate = categoryTabView
        categoryTabView.delegate = cheffiRecommendationCatogoryPageView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 48, left: 0, bottom: 0, right: 0)
        )
    }
    private func setUp() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(Constants.cellInset)
        }
        
        contentView.addSubview(exclamationButton)
        exclamationButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.bottom.equalTo(titleLabel)
        }

        contentView.addSubview(categoryTabView)
        categoryTabView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }

        contentView.addSubview(cheffiRecommendationCatogoryPageView)
        cheffiRecommendationCatogoryPageView.snp.makeConstraints {
            $0.top.equalTo(categoryTabView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(viewModel: ViewModel) {
        bind(to: viewModel)
        initialize.send(())
    }
}

extension CheffiRecommendationCell: Bindable {
    
    func bind(to viewModel: ViewModel) {
        cancellables.forEach {
            $0.cancel()
        }
        cancellables =  Set<AnyCancellable>()
        
        let input = ViewModel.Input(
            initialize: initialize
        )
        let output = viewModel.transform(input: input)
        
        output.categories
            .filter { _ in !viewModel.initialized }
            .sink { (categories, viewModels) in
                self.categoryTabView.setUpTags(tags: categories)
                self.cheffiRecommendationCatogoryPageView.configure(viewModels: viewModels)
            }.store(in: &cancellables)
    }
}
