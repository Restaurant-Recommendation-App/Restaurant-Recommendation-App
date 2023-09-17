//
//  PopularRestaurantCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit
import Combine

class PopularRestaurantCell: UITableViewCell {
    typealias ViewModel = PopularRestaurantViewModel
    
    var cancellables = Set<AnyCancellable>()
    
    private let mainPopularRestaurantView = MainPopularRestaurantView()
    private let popularRestaurantContentsView = PopularRestaurantContentsView()
    
    private let initialize = PassthroughSubject<Void, Never>()
    
    enum Constants {
        static let inset: CGFloat = 16.0
    }
    
    private let pageControlButton: PageControlButton = {
        let button = PageControlButton()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        contentView.addSubview(mainPopularRestaurantView)
        mainPopularRestaurantView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.inset)
            $0.height.equalTo(100)
        }
        
        contentView.addSubview(popularRestaurantContentsView)
        popularRestaurantContentsView.snp.makeConstraints {
            $0.top.equalTo(mainPopularRestaurantView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(570)
        }
        
        contentView.addSubview(pageControlButton)
        pageControlButton.snp.makeConstraints {
            $0.top.equalTo(popularRestaurantContentsView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(127)
            $0.height.equalTo(40)
        }
    }
    
    func configure(viewModel: ViewModel) {
        bind(to: viewModel)
        initialize.send(())
    }
}

extension PopularRestaurantCell: Bindable {
    
    func bind(to viewModel: ViewModel) {
        let input = ViewModel.Input(initialize: initialize)
        let output = viewModel.transform(input: input)
        
        output.contentsViewModel
            .sink { viewModels in
                self.popularRestaurantContentsView.configure(
                    viewModels: viewModels,
                    didTappedPageButton: self.pageControlButton.tapped)
                
                self.pageControlButton.configure(
                    currentPage: 1,
                    limitPage: viewModels.count,
                    swiped: self.popularRestaurantContentsView.didSwiped)
            }.store(in: &cancellables)
    }
}
