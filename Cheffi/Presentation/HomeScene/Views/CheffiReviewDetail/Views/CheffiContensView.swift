//
//  CheffiContensView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/31.
//

import UIKit

class CheffiContensView: BaseView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageLabel: UILabel!
    
    private var photos: [ReviewPhotoInfoDTO] = [] {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<Int, ReviewPhotoInfoDTO>()
            snapshot.appendSections([0])
            snapshot.appendItems(photos)
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ReviewPhotoInfoDTO>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MAKR: - Private
    private func setupViews() {
        collectionView.delegate = self
        collectionView.register(nibWithCellClass: CheffiContensViewImageCell.self)
        
        // Initialize data source
        dataSource = UICollectionViewDiffableDataSource<Int, ReviewPhotoInfoDTO>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, photoInof: ReviewPhotoInfoDTO) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withClass: CheffiContensViewImageCell.self, for: indexPath)
            cell.toggleViewVisibility(isHidden: indexPath.row != 0)
            cell.updatePhotoInfo(with: photoInof)
            return cell
        }
    }
    
    private func updatePageLabel(currentPage: Int, totalPages: Int) {
        let currentPageString = "\(currentPage + 1)"
        let totalPagesString = "/\(totalPages)"
        
        let attributedText = NSMutableAttributedString(string: currentPageString, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.cheffiGray2,
            NSAttributedString.Key.font: Fonts.suit.weight500.size(14.0)
        ])
        attributedText.append(NSAttributedString(string: totalPagesString, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.cheffiGray6,
            NSAttributedString.Key.font: Fonts.suit.weight400.size(14.0)
        ]))
        
        pageLabel.attributedText = attributedText
    }

    
    // MARK: - Public
    func setImages(_ photos: [ReviewPhotoInfoDTO]) {
        self.photos = photos
        self.updatePageLabel(currentPage: 0, totalPages: photos.count)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CheffiContensView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        updatePageLabel(currentPage: currentPage, totalPages: photos.count)
    }
}
