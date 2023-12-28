//
//  SearchCategoryListCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/12/24.
//

import UIKit
import SnapKit

class SearchCategoryListCell: UICollectionViewCell {
    var viewModel: [String] = []
    
    lazy var listView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupListView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func layout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 44
             
        return UICollectionViewCompositionalLayout(sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
            let searchViewLayout = SearchViewLayout()
            return searchViewLayout.getCollectionViewSectionLayout(withSection: section)
        }, configuration: config )
    }
    
    private func setupLayout() {
        contentView.addSubview(listView)
        listView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupListView() {
        listView.dataSource = self
        
        if let layout = listView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        listView.showsHorizontalScrollIndicator = false
        listView.showsVerticalScrollIndicator = false
        listView.backgroundColor = .clear
        
        listView.register(cellWithClass: RecentSearchCell.self)
        listView.register(cellWithClass: RecommendedSearchCell.self)
        listView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: SearchViewHeader.self)
    }
    
    func configure(viewModel: [String]) {
        self.viewModel = viewModel
        listView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchCategoryListCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.count
        // TODO: 이번 mvp 에서는 추천 검색어는 제외되었으므로 제거 필요
        default:
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withClass: RecentSearchCell.self, for: indexPath)
            cell.update(title: viewModel[indexPath.item])
            return cell
        // TODO: 이번 mvp 에서는 추천 검색어는 제외되었으므로 제거 필요
        case 1:
            let cell = collectionView.dequeueReusableCell(withClass: RecommendedSearchCell.self, for: indexPath)
            cell.update(title: recommendSearchMock[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withClass: SearchViewHeader.self, for: indexPath)
        
        header.configure(title: searchViewHeaderTitle[indexPath.section])
        
        return header
    }
}

// TODO: 제거 필요
let recommendSearchMock = ["용리단길", "참지말고 참치", "양리단길!!", "오마카세 잘하는 곳", "와인", "피자는 또 못참지", "중국요리 잘하는곳", "설리단길", "생선 찌개", "맛있는거 먹자"]
