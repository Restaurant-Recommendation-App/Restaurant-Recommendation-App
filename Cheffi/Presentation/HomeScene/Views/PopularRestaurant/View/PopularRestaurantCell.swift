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
    
    private let showAllContentsButton: ShowAllContentsButton = {
        let button = ShowAllContentsButton()
        button.setTItle("전체보기".localized(), direction: .right)
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
            $0.height.equalTo(400)
        }
        
        contentView.addSubview(popularRestaurantContentsView)
        popularRestaurantContentsView.snp.makeConstraints {
            $0.top.equalTo(mainPopularRestaurantView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(Constants.inset)
            $0.height.equalTo(270)
        }
        
        contentView.addSubview(showAllContentsButton)
        showAllContentsButton.snp.makeConstraints {
            $0.top.equalTo(popularRestaurantContentsView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.inset)
            $0.height.equalTo(40)
        }
        
        // Action
        showAllContentsButton.didTapViewAllHandler = { [weak self] in
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
        
        output.models
            .sink { models in
                // TODO: 새로운 뷰 작업 필요
//                self.popularRestaurantContentsView.configure(viewModels: models, scrolledToBottom: nil, contentOffsetY: nil)
            }.store(in: &cancellables)
    }
}
