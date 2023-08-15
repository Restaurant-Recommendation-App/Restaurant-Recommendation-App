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
    private var viewModels = [[RestaurantContentsViewModel]]()

    var categoryPageViewDelegate: CheffiRecommendationCategoryPageViewDelegate?
        
    private var isScrollingWithTab = false
    
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
        dataSource = self
        
        register(cellWithClass: CheffiRecommendationCategoryPageCell.self)
        allowsSelection = false
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
    }
    
    func configure(viewModels: [[RestaurantContentsViewModel]], currentCategoryPageIndex: Int?) {
        self.viewModels = viewModels
        reloadData {
            // 네번째 카테고리부터 더보기 버튼 누를시 의도치 않게 왼쪽 카테고리로 이동되므로 이를 막기 위함
            // TODO: 문제 원인 파악후 해결(아래 코듣 제거) 필요
            if let index = currentCategoryPageIndex {
                self.safeScrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
}

extension CheffiRecommendationCategoryPageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CheffiRecommendationCategoryPageCell.self, for: indexPath)

        cell.configure(viewModels: viewModels[indexPath.row])
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
