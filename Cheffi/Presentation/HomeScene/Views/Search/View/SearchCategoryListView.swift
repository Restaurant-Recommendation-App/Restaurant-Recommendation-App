//
//  SearchCategoryListView.swift
//  Cheffi
//
//  Created by RONICK on 2023/12/24.
//

import UIKit

class SearchCategoryListView: UICollectionView {
    var viewModels: [[String]] = [[]]
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupCollectionView() {
        delegate = self
        dataSource = self
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isPagingEnabled = true
        isScrollEnabled = false
        isPrefetchingEnabled = true
        backgroundColor = .clear

        register(cellWithClass: SearchCategoryListCell.self)
    }
    
    func configure(viewModels: [[String]]) {
        self.viewModels = viewModels
        reloadData()
    }
    
    func didTapCategory(index: Int) {
        let rect = layoutAttributesForItem(at: IndexPath(row: index, section: 0))?.frame
        scrollRectToVisible(rect!, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension SearchCategoryListView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: SearchCategoryListCell.self, for: indexPath)
        cell.configure(viewModel: viewModels[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchCategoryListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
}
