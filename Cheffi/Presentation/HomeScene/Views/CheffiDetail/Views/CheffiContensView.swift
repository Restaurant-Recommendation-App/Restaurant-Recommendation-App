//
//  CheffiContensView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/31.
//

import UIKit

struct ImageItem: Hashable {
    let id: String
    let image: UIImage
}

class CheffiContensView: BaseView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageLabel: UILabel!
    
    // test code
    private var items: [ImageItem] = [] {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<Int, ImageItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(items)
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ImageItem>?
    
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
        dataSource = UICollectionViewDiffableDataSource<Int, ImageItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ImageItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withClass: CheffiContensViewImageCell.self, for: indexPath)
            cell.toggleViewVisibility(isHidden: indexPath.row != 0)
            cell.setImage(item.image)
            return cell
        }
    }
    
    private func updatePageLabel(currentPage: Int, totalPages: Int) {
        pageLabel.text = "\(currentPage + 1)/\(totalPages)"
    }
    
    // MARK: - Public
    func setImages(_ items: [ImageItem]) {
        self.items = items
        self.updatePageLabel(currentPage: 0, totalPages: items.count)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CheffiContensView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        updatePageLabel(currentPage: currentPage, totalPages: items.count)
    }
}
