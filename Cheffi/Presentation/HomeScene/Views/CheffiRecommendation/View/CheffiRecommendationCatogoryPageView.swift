//
//  CheffiRecommendationCatogoryPageView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/18.
//

import UIKit

protocol CheffiRecommendationCategoryPageViewDelegate {
    func didSwipe(indexPath: IndexPath?)
}

final class CheffiRecommendationCategoryPageView: UICollectionView {
    
    var categoryPageViewDelegate: CheffiRecommendationCategoryPageViewDelegate?
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, String>?
    
    var isScrollingWithTab = false
    
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
        
        diffableDataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: self) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withClass: CheffiRecommendationCategoryPageCell.self, for: indexPath)
            
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(["한식", "양식", "중식", "일식", "퓨전", "샐러드"])
        
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
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
