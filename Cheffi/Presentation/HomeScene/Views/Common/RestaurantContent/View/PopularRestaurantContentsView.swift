//
//  PopularRestaurantContentCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit
import Combine

class PopularRestaurantContentsView: UICollectionView {
    enum Constants {
        static let cellHeight = 270
        static let cellLineSpcaing = 24
    }
            
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, RestaurantContentsViewModel>?
    
    private var scrolledToBottom: PassthroughSubject<CGFloat, Never>?
    var currentCategoryPageIndex = 0
    
    var items = [RestaurantContentsViewModel]()
    
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
    
    func configure(viewModels: [RestaurantContentsViewModel], scrolledToBottom: PassthroughSubject<CGFloat, Never>?, contentOffsetY: CGFloat?) {
        self.items = viewModels
        self.scrolledToBottom = scrolledToBottom
        
        reloadData {
            self.contentOffset.y = contentOffsetY ?? 0
        }
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
        
        if contentOffsetY > actualHeight {
            scrolledToBottom?.send(contentOffsetY)
        }
    }
}
