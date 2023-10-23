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
    @IBOutlet private weak var tagListView: TagListView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageNavigatorBackgroundView: UIView!
    private var pageNavigatorView: PageNavigatorView? = nil
    private var didSwiped = PassthroughSubject<Int, Never>()
    
    private enum Constants {
        static let cellInset: CGFloat = 16.0
        static let cellHeight: CGFloat = 64.0
        static let itemsPerPage: Int = 3
    }
    
    weak var delegate: SimilarChefCellDelegate?
    private var viewModel: SimilarChefViewModelType?
    private var cancellables = Set<AnyCancellable>()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    func configure(with viewModel: SimilarChefViewModelType) {
        self.viewModel = viewModel
        
        viewModel.output.combinedData
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // TODO: - 에러메시지 처리
                    debugPrint("combine data ------------------------------------------")
                    debugPrint(error)
                    debugPrint("------------------------------------------")
                }
            }, receiveValue: { [weak self] tags, users in
                print("-------> combineData 호출")
                self?.tagListView.setupTags(tags)
                self?.reloadData(users: users)
                self?.makePagenavigatorView(users: users)
            })
            .store(in: &cancellables)
        
        viewModel.output.tags
            .sink { [weak self] tags in
                let savedTags = UserDefaultsManager.HomeSimilarChefInfo.tags
                if savedTags.isEmpty, let firstTag = tags.first {
                    self?.viewModel?.input.setSelectTags([firstTag])
                } else {
                    self?.viewModel?.input.setSelectTags(savedTags)
                }
            }
            .store(in: &cancellables)
        
        viewModel.input.requestGetTags(type: .food)
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
            self?.viewModel?.input.setSelectTags(tags)
        }
    }
    
    private func reloadData(users: [User]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(users.map { $0.nickname })
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func makePagenavigatorView(users: [User]) {
        pageNavigatorView?.removeFromSuperview()
        pageNavigatorView = nil
        pageNavigatorView = PageNavigatorView()
        pageNavigatorBackgroundView.addSubview(pageNavigatorView!)
        pageNavigatorView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(125)
            make.height.equalTo(32)
        }
        
        let totalPage = (users.count + Constants.itemsPerPage - 1) / Constants.itemsPerPage
        pageNavigatorView?.configure(currentPage: 1, limitPage: totalPage, swiped: didSwiped)
        pageNavigatorView?.tapped
            .sink(receiveValue: { [weak self] pageType in
                self?.changePage(to: pageType)
            })
            .store(in: &cancellables)
    }
    
    private func changePage(to pageType: PageNavigatorView.PageType) {
        let currentOffset = collectionView.contentOffset.x
        let pageWidth = collectionView.frame.size.width
        let currentPageIndex = Int(currentOffset / pageWidth)
        let totalPageCount = collectionView.numberOfItems(inSection: 0)
        
        var targetPageIndex: Int {
            switch pageType {
            case .prev:
                return max(currentPageIndex - 1, 0)
            case .next:
                return min(currentPageIndex + 1, totalPageCount - 1)
            default:
                return 0
            }
        }
        
        if targetPageIndex != currentPageIndex {
            let newOffset = CGFloat(targetPageIndex) * pageWidth
            collectionView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: true)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let pageIndex = Int(offsetX / scrollView.frame.width)
        self.didSwiped.send(pageIndex)
    }
}
