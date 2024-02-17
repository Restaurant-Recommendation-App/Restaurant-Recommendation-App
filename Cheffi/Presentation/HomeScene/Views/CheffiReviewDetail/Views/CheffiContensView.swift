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
    private var reviewInfo: ReviewInfoDTO? = nil
    private var photos: [PhotoInfoDTO] = [] {
        didSet {
            reloadData()
        }
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotoInfoDTO>?
    
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
        dataSource = UICollectionViewDiffableDataSource<Int, PhotoInfoDTO>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, photoInfo: PhotoInfoDTO) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withClass: CheffiContensViewImageCell.self, for: indexPath)
            cell.toggleViewVisibility(isHidden: indexPath.row != 0)
            cell.configure(with: photoInfo, reviewInfo: self.reviewInfo)
            return cell
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoInfoDTO>()
        snapshot.appendSections([0])
        snapshot.appendItems(photos)
        dataSource?.apply(snapshot, animatingDifferences: true)
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
    func setReviewInfo(_ reviewInfo: ReviewInfoDTO) {
        self.reviewInfo = reviewInfo
        self.photos = reviewInfo.photos ?? []
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
