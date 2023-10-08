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
    
    var setUpTabNames: (([String]) -> ())?
    
    private enum Constants {
        static let cellInset: CGFloat = 16.0
        static let otherContentsSize: CGFloat = 270
    }
    
    let cheffiRecommendationCatogoryPageView = CheffiRecommendationCategoryPageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(
//            by: UIEdgeInsets(top: 48, left: 0, bottom: 0, right: 0)
//        )
    }
    private func setUp() {

        contentView.addSubview(cheffiRecommendationCatogoryPageView)
        cheffiRecommendationCatogoryPageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(viewModel: ViewModel) {
        bind(to: viewModel)
        initialize.send(())
    }
    
    func configure(categoryPageViewDelegate: CheffiRecommendationCategoryPageViewDelegate) {
        cheffiRecommendationCatogoryPageView.configure(delegate: categoryPageViewDelegate)
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
            .sink { [weak self] (categories, viewModels) in
                self?.setUpTabNames?(categories)
                self?.cheffiRecommendationCatogoryPageView.configure(viewModels: viewModels)
            }.store(in: &cancellables)
    }
}
