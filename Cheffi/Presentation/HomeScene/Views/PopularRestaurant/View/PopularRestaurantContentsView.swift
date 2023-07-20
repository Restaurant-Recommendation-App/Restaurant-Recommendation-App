//
//  PopularRestaurantContentCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit

class PopularRestaurantContentsView: UICollectionView {
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, String>?
    
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
        
        snapshot.appendSections([0, 1])
        snapshot.appendItems(["Test1", "Test2"])
        
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension PopularRestaurantContentsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: bounds.width / 2 - 6.5, height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
