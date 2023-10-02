//
//  RestaurantContentCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit
import Combine

class RestaurantContentCell: UICollectionViewCell {
    
    typealias ViewModel = RestaurantContentItemViewModel
    
    private let restaurantContentView = RestaurantContentView()
    
    var cancellables = Set<AnyCancellable>()
    
    private var initialize = PassthroughSubject<Void, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        contentView.addSubview(restaurantContentView)
        restaurantContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
        
    func configure(viewModel: ViewModel, isMainContent: Bool = false) {
        
        restaurantContentView.configure(
            title: viewModel.title,
            subtitle: viewModel.subtitle,
            timeLockType: viewModel.timeLockType,
            isMainContent: isMainContent
        )
        initialize = PassthroughSubject<Void, Never>()
        bind(to: viewModel)
        initialize.send(())
    }
}

extension RestaurantContentCell: Bindable {
    func bind(to viewModel: ViewModel) {
        cancellables.forEach {
            $0.cancel()
        }
        cancellables = Set<AnyCancellable>()
        
        let input = ViewModel.Input(initialize: initialize.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.timeLockType
            .receive(on: DispatchQueue.main)
            .sink {
                self.restaurantContentView.updateTimer(timeLockType: $0)
            }.store(in: &cancellables)
    }
}
