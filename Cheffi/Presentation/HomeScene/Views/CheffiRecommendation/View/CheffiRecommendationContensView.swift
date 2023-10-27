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
        static let cellLineSpcaing = 16
    }
            
    private var initialized = PassthroughSubject<Void, Never>()
    private var verticallyScrolled = PassthroughSubject<ContentOffsetY, Never>()
    private var scrolledToBottom = PassthroughSubject<Void, Never>()
    
    private var contentItemType = RestaurantContentItemType.twoColumn
    private var contentColumnStyle = ContentsColumnStyle.two
    
    var viewModel: ViewModel?
    var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
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
    
    func configure(viewModel: ViewModel, columnStyle: ContentsColumnStyle = .two) {
        
        setColumnStyle(columnStyle: columnStyle)
        
        initialized = PassthroughSubject<Void, Never>()
        verticallyScrolled = PassthroughSubject<ContentOffsetY, Never>()
        scrolledToBottom = PassthroughSubject<Void, Never>()
        
        bind(to: viewModel)
        initialized.send(())
    }
    
    func setColumnStyle(columnStyle: ContentsColumnStyle) {
        contentColumnStyle = columnStyle
        switch columnStyle {
        case .one:
            contentItemType = .oneColumn
        case .two:
            contentItemType = .twoColumn
        }
        reloadData()
    }
}

extension CheffiRecommendationContensView: Bindable {
    func bind(to viewModel: ViewModel) {
        cancellables.forEach {
            $0.cancel()
        }
        cancellables = Set<AnyCancellable>()
        
        self.viewModel = viewModel
        
        let input = ViewModel.Input(
            initialize: initialized.eraseToAnyPublisher(),
            verticallyScrolled: verticallyScrolled.eraseToAnyPublisher(),
            scrolledToBottom: scrolledToBottom.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.contentItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadData()
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
        viewModel?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: RestaurantContentCell.self, for: indexPath)
        cell.configure(viewModel: viewModel!.items[indexPath.row], contentItemType: contentItemType)
        
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

extension CheffiRecommendationContensView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch contentColumnStyle {
        case .one:
            return CGSize(
                width: Double(bounds.width) - Double(Constants.cellLineSpcaing * 2),
                height: Double(bounds.width) + 80
            )
        case .two:
            return CGSize(
                width: Double(bounds.width / 2) - Double(Constants.cellLineSpcaing / 2) - Double(Constants.cellLineSpcaing),
                height: Double(Constants.cellHeight)
            )
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(Constants.cellLineSpcaing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: CGFloat(Constants.cellLineSpcaing),
            bottom: 0,
            right: CGFloat(Constants.cellLineSpcaing)
        )
    }
}
