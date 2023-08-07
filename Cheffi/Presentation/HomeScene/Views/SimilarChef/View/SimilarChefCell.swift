//
//  SimilarChefCell.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit
import Combine

protocol SimilarChefCellDelegate: AnyObject {
    func didTapShowSimilarChefList()
}

class SimilarChefCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var tagListView: TagListView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var showAllContentsDirection: ShowAllContentsButton!
    
    enum Constants {
        static let cellInset: CGFloat = 16.0
        static let cellHeight: CGFloat = 64.0
    }
    
    weak var delegate: SimilarChefCellDelegate?
    private var viewModel: SimilarChefViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    func configure(with viewModel: SimilarChefViewModel) {
        self.viewModel = viewModel
        
        viewModel.combinedData
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // TODO: - 에러메시지 처리
                    debugPrint("------------------------------------------")
                    debugPrint(error)
                    debugPrint("------------------------------------------")
                }
            }, receiveValue: { [weak self] tags, profiles in
                self?.tagListView.setupTags(tags)
                
                var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
                snapshot.appendSections([0])
                snapshot.appendItems(profiles.map { $0.name })
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            })
            .store(in: &cancellables)
        viewModel.selectTags(UserDefaultsManager.HomeSimilarChefInfo.tags)
    }
    
    // MARK: - Private
    private func setupViews() {
        collectionView.delegate = self
        collectionView.register(nibWithCellClass: SimilarChefProfileCell.self)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        // Initialize data source
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withClass: SimilarChefProfileCell.self, for: indexPath)
            cell.configure(with: item)
            return cell
        }
        
        // TagListView
        tagListView.didTapTagsHandler = { [weak self] tags in
            self?.viewModel?.selectTags(tags)
        }
        
        // show all contents button
        showAllContentsDirection.setTItle("전체보기".localized(), direction: .right)
        showAllContentsDirection.didTapViewAllHandler = { [weak self] in
            self?.delegate?.didTapShowSimilarChefList()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SimilarChefCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.cellInset, left: 0.0,
                            bottom: Constants.cellInset, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
