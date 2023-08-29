//
//  PopularRestaurantContentCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit
import Combine

class PopularRestaurantContentsView: UICollectionView {
    
    typealias ViewModel = RestaurantContentsViewModel
    typealias ContentOffsetY = CGFloat
    
    enum Constants {
        static let cellHeight = 270
        static let cellLineSpcaing = 24
    }
            
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, RestaurantContentItemViewModel>?
        
    private var items = [RestaurantContentItemViewModel]()
        
    private var initialized = PassthroughSubject<Void, Never>()
    private var verticallyScrolled = PassthroughSubject<ContentOffsetY, Never>()
    private var scrolledToBottom = PassthroughSubject<Void, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpCollectionView() {
        delegate = self
        dataSource = self
        
        register(cellWithClass: RestaurantContentCell.self)
        allowsSelection = false
        isScrollEnabled = false
        showsVerticalScrollIndicator = true
    }
    
    func configure(viewModel: ViewModel) {
        initialized = PassthroughSubject<Void, Never>()
        verticallyScrolled = PassthroughSubject<ContentOffsetY, Never>()
        scrolledToBottom = PassthroughSubject<Void, Never>()
        
        bind(to: viewModel)
        initialized.send(())
    }
}

extension PopularRestaurantContentsView: Bindable {
    func bind(to viewModel: ViewModel) {
        cancellables.forEach {
            $0.cancel()
        }
        cancellables = Set<AnyCancellable>()
        
        let input = ViewModel.Input(
            initialize: initialized.eraseToAnyPublisher(),
            verticallyScrolled: verticallyScrolled.eraseToAnyPublisher(),
            scrolledToBottom: scrolledToBottom.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.contentItems
            .receive(on: DispatchQueue.main)
            .sink {
                self.items = $0
                self.reloadData()
            }.store(in: &cancellables)
                
        output.scrolleOffsetY
            .receive(on: DispatchQueue.main)
            .sink {
                self.contentOffset.y = $0
            }.store(in: &cancellables)
    }
}

extension PopularRestaurantContentsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: RestaurantContentCell.self, for: indexPath)
        
        cell.configure(
            contentImageHeight: CGFloat(items[indexPath.row].contentImageHeight),
            title: items[indexPath.row].title,
            subtitle: items[indexPath.row].subtitle
        )
            
        return cell
    }
}

extension PopularRestaurantContentsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: Double(bounds.width / 2) - Double(Constants.cellLineSpcaing / 2),
            height: Double(Constants.cellHeight)
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(Constants.cellLineSpcaing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = contentOffset.y
        let contentHeight = contentSize.height
        let height = frame.height
        let actualHeight = (contentHeight - height > 0) ? contentHeight - height : 0
        
        verticallyScrolled.send(contentOffsetY)
        if contentOffsetY > actualHeight {
            scrolledToBottom.send(())
        }
    }
}
