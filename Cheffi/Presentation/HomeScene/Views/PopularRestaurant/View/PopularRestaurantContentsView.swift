//
//  PopularRestaurantContentsView.swift
//  Cheffi
//
//  Created by RONICK on 2023/09/06.
//

import UIKit
import Combine

final class PopularRestaurantContentsView: UICollectionView {
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, PopularRestaurantContentsItemViewModel>?
    
    var didSwiped = PassthroughSubject<Int, Never>()
    private var didTapPageButton: AnyPublisher<PageControlButton.PageType, Never> = Just(.current).eraseToAnyPublisher()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var isScrollingWithPageControl = false
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        
        delegate = self
        register(cellWithClass: PopularRestaurantContentsCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        
        diffableDataSource = UICollectionViewDiffableDataSource<Int, PopularRestaurantContentsItemViewModel>(collectionView: self) { (collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withClass: PopularRestaurantContentsCell.self, for: indexPath)
            cell.configure(viewModel: item)
            return cell
        }
    }
    
    private func configureItems(items: [PopularRestaurantContentsItemViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PopularRestaurantContentsItemViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func configure(viewModels: [PopularRestaurantContentsItemViewModel], didTappedPageButton: AnyPublisher<PageControlButton.PageType, Never>) {
        configureItems(items: viewModels)
        
        self.didTapPageButton = didTappedPageButton.eraseToAnyPublisher()
        bind()
    }
    
    func bind() {
        didTapPageButton
            .receive(on: DispatchQueue.main)
            .sink {
                var indexPath: IndexPath
                switch $0 {
                case .prev: indexPath = IndexPath(row: self.visibleIndexPath!.row - 1, section: 0)
                case .next: indexPath = IndexPath(row: self.visibleIndexPath!.row + 1, section: 0)
                default: indexPath = self.visibleIndexPath!
                }
                self.safeScrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.isScrollingWithPageControl = true                
            }.store(in: &cancellables)
    }
    
}

extension PopularRestaurantContentsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isScrollingWithPageControl {
            didSwiped.send(visibleIndexPath?.row ?? 0)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isScrollingWithPageControl = false
    }
}
