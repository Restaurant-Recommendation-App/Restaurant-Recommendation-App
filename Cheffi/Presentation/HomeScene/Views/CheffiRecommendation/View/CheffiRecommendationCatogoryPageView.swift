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
    
    static var updatedContentHeight = false
    
    var categoryPageViewDelegate: CheffiRecommendationCategoryPageViewDelegate?
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, [RestaurantContentsViewModel]>?
    
    private var isScrollingWithTab = false
    
    private var updateContentHeight: ((CGSize) -> Void)?
    
    let scrolledCategory = PassthroughSubject<Int, Never>()
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        delegate = self
        
        register(cellWithClass: CheffiRecommendationCategoryPageCell.self)
        allowsSelection = false
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
        
        diffableDataSource = UICollectionViewDiffableDataSource<Int, [RestaurantContentsViewModel]>(collectionView: self) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: [RestaurantContentsViewModel]) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withClass: CheffiRecommendationCategoryPageCell.self, for: indexPath)

            cell.layoutIfNeeded()
            cell.configure(viewModels: item)
            
            if !CheffiRecommendationCategoryPageView.updatedContentHeight {
                self.updateContentHeight?(cell.contentSize)
                CheffiRecommendationCategoryPageView.updatedContentHeight = true
            }
            
            return cell
        }
    }
    
    private func loadItems(items: [[RestaurantContentsViewModel]], currentCategoryPageIndex: Int) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, [RestaurantContentsViewModel]>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        
        diffableDataSource?.apply(snapshot, animatingDifferences: true) {
            self.safeScrollToItem(at: IndexPath(row: currentCategoryPageIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        reloadData()
    }
    
    func configure(viewModels: [[RestaurantContentsViewModel]], currentCategoryPageIndex: Int, updateContentHeight: ((CGSize) -> Void)?) {
        self.updateContentHeight = updateContentHeight
        loadItems(items: viewModels, currentCategoryPageIndex: currentCategoryPageIndex)
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
