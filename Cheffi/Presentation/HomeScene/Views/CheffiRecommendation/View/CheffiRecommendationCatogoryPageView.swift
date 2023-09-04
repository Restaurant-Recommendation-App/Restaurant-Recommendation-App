//
//  CheffiRecommendationCatogoryPageView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/18.
//

import UIKit
import Combine

protocol CheffiRecommendationCategoryPageViewDelegate: AnyObject {
    func didSwipe(indexPath: IndexPath?)
}

final class CheffiRecommendationCategoryPageView: UICollectionView {
    typealias categoryIndex = Int
    private var viewModels = [[RestaurantContentItemViewModel]]()

    weak var categoryPageViewDelegate: CheffiRecommendationCategoryPageViewDelegate?
        
    private var isScrollingWithTab = false
            
    private var items = [RestaurantContentsViewModel]()
        
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
    
    func configure(viewModels: [RestaurantContentsViewModel]) {
        self.items = viewModels
        reloadData()
    }
}

extension CheffiRecommendationCategoryPageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CheffiRecommendationCategoryPageCell.self, for: indexPath)
        
        cell.configure(viewModel: items[indexPath.row])
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
