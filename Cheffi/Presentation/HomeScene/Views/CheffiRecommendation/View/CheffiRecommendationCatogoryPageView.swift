//
//  CheffiRecommendationCatogoryPageView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/18.
//

import UIKit
import Combine

protocol CheffiRecommendationCategoryPageViewDelegate {
    func didSwipe(indexPath: IndexPath?)
}

final class CheffiRecommendationCategoryPageView: UICollectionView {
    typealias categoryIndex = Int
    private var viewModels = [[RestaurantContentsViewModel]]()

    var categoryPageViewDelegate: CheffiRecommendationCategoryPageViewDelegate?
        
    private var isScrollingWithTab = false
    
    let scrolledCategory = PassthroughSubject<categoryIndex, Never>()
    let scrolledToBottom = PassthroughSubject<CGFloat, Never>()
    var contentsOffsetY = [CGFloat]()
    
    var cancellables = Set<AnyCancellable>()
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        delegate = self
        dataSource = self
        
        register(cellWithClass: CheffiRecommendationCategoryPageCell.self)
        allowsSelection = false
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
    }
    
    func configure(viewModels: [[RestaurantContentsViewModel]], currentCategoryPageIndex: Int?, contentsOffsetY: [CGFloat]?) {
        self.viewModels = viewModels
        self.contentsOffsetY = contentsOffsetY ?? [CGFloat]()
        
        let currentCategoryPageIndex = currentCategoryPageIndex ?? 0
        let cell = cellForItem(at: IndexPath(row: currentCategoryPageIndex, section: 0)) as? CheffiRecommendationCategoryPageCell
                
        cell?.configure(
            viewModels: viewModels[currentCategoryPageIndex],
            scrolledToBottom: scrolledToBottom,
            contentOffsetY: self.contentsOffsetY[currentCategoryPageIndex]
        )
    }
}

extension CheffiRecommendationCategoryPageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CheffiRecommendationCategoryPageCell.self, for: indexPath)
        
        cell.configure(
            viewModels: viewModels[indexPath.row],
            scrolledToBottom: scrolledToBottom,
            contentOffsetY: contentsOffsetY[safe: indexPath.row] ?? 0
        )
        return cell
    }
}

extension CheffiRecommendationCategoryPageView: UICollectionViewDelegateFlowLayout {
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
        if !isScrollingWithTab {
            categoryPageViewDelegate?.didSwipe(indexPath: visibleIndexPath)
            scrolledCategory.send(visibleIndexPath?.row ?? 0)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isScrollingWithTab = false
    }
}

extension CheffiRecommendationCategoryPageView: CategoryTabViewDelegate {
    func didTapCategory(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        safeScrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        isScrollingWithTab = true
    }
}
