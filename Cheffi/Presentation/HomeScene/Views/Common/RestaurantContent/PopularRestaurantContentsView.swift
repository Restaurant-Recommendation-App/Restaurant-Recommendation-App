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
        static let cellLineSpcaing = 13
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, String>?
    
    init(items: [String] = ["Test1", "Test2"]) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setUpCollectionView(items: items)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpCollectionView(items: [String]) {
        delegate = self
        
        register(cellWithClass: RestaurantContentCell.self)
        allowsSelection = false
        
        diffableDataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: self) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withClass: RestaurantContentCell.self, for: indexPath)
            cell.configure(
                contentImageHeight: 165,
                title: "그시절낭만의 근본 경양식 돈가스",
                subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 아물.."
            )
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        
        let sections = items.enumerated().map { $0.offset }
        snapshot.appendSections(sections)
        snapshot.appendItems(items)
        
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
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
