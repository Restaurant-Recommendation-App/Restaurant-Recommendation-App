//
//  CheffiRecommendationContensView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit
import Combine

/// 리스트 화면 구성 상태
enum ContentsColumnStyle {
    case one
    case two
}

class CheffiRecommendationContensView: UICollectionView {
    
    typealias ViewModel = RestaurantContentsViewModel
    typealias ContentOffsetY = CGFloat
    
    private enum Constants {
        static let cellHeight = 270
        static let cellLineSpcaing = 24
    }
    
    private var items = [RestaurantContentItemViewModel]()
        
    private var initialized = PassthroughSubject<Void, Never>()
    private var verticallyScrolled = PassthroughSubject<ContentOffsetY, Never>()
    private var scrolledToBottom = PassthroughSubject<Void, Never>()
    
    private var contentItemType = RestaurantContentItemType.twoColumn
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
        
        setColumnStyle(columnStyle: .two)
        bind(to: viewModel)
        initialized.send(())
    }
    
    func setColumnStyle(columnStyle: ContentsColumnStyle) {
        let layout = UICollectionViewFlowLayout()
        
        switch columnStyle {
        case .one:
            layout.itemSize = CGSize(
                width: Double(bounds.width),
                height: Double(bounds.width) + 100
            )
            layout.minimumLineSpacing = CGFloat(Constants.cellLineSpcaing)
            layout.minimumInteritemSpacing = 0
            contentItemType = .oneColumn
        case .two:
            layout.itemSize = CGSize(
                width: Double(bounds.width / 2) - Double(Constants.cellLineSpcaing / 2),
                height: Double(Constants.cellHeight)
            )
            layout.minimumLineSpacing = CGFloat(Constants.cellLineSpcaing)
            layout.minimumInteritemSpacing = 0
            contentItemType = .twoColumn
        }
        
        self.collectionViewLayout = layout
        reloadData()
    }
}

extension CheffiRecommendationContensView: Bindable {
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
            .sink { [weak self] items in
                self?.setColumnStyle(columnStyle: .two)
                self?.items = items
            }.store(in: &cancellables)
                
        output.scrolleOffsetY
            .receive(on: DispatchQueue.main)
            .sink {
                self.contentOffset.y = $0
            }.store(in: &cancellables)
    }
}

extension CheffiRecommendationContensView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: RestaurantContentCell.self, for: indexPath)
        cell.configure(viewModel: items[indexPath.row], contentItemType: contentItemType)
        
        return cell
    }
}

extension CheffiRecommendationContensView: UICollectionViewDelegate {
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
