//
//  PopularRestaurantContentCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit

class PopularRestaurantContentsView: UICollectionView {
    enum Constants {
        static let cellHeight = 270
        static let cellLineSpcaing = 24
    }
            
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, RestaurantContentsViewModel>?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpCollectionView() {
        delegate = self
        
        register(cellWithClass: RestaurantContentCell.self)
        allowsSelection = false
        isScrollEnabled = false
                
        diffableDataSource = UICollectionViewDiffableDataSource<Int, RestaurantContentsViewModel>(collectionView: self) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: RestaurantContentsViewModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withClass: RestaurantContentCell.self, for: indexPath)
            cell.configure(
                contentImageHeight: CGFloat(item.contentImageHeight),
                title: item.title,
                subtitle: item.subtitle
            )
            return cell
        }
    }
    
    private func loadItems(items: [RestaurantContentsViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RestaurantContentsViewModel>()
        
        let sections = items.enumerated().map { $0.offset }
        snapshot.appendSections(sections)
        snapshot.appendItems(items)
        
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func configure(viewModels: [RestaurantContentsViewModel]) {
        self.loadItems(items: viewModels)
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
}
