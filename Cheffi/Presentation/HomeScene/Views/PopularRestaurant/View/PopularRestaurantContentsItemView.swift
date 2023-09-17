//
//  PopularRestaurantContentsItemView.swift
//  Cheffi
//
//  Created by RONICK on 2023/09/06.
//

import UIKit
import Combine

class PopularRestaurantContentsItemView: UICollectionView {
    
    enum Constants {
        static let cellHeight = 270
        static let cellLineSpcaing = 24
    }
    
    typealias ViewModel = PopularRestaurantContentsItemViewModel
    
    var cancellables = Set<AnyCancellable>()
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, RestaurantContentItemViewModel>?
    
    private var initialize = PassthroughSubject<Void, Never>()
    
    private var items = [RestaurantContentItemViewModel]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {        
        register(cellWithClass: RestaurantContentCell.self)
        delegate = self
        
        diffableDataSource = UICollectionViewDiffableDataSource<Int, RestaurantContentItemViewModel>(collectionView: self) { (collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withClass: RestaurantContentCell.self, for: indexPath)
            
            cell.configure(
                title: item.title,
                subtitle: item.subtitle,
                isMainContent: self.validateFirstContents(with: indexPath)
            )

            return cell
        }
    }
    
    private func configureItems(items: [RestaurantContentItemViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RestaurantContentItemViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func configure(viewModel: ViewModel) {
        initialize = PassthroughSubject<Void, Never>()
        bind(to: viewModel)
        initialize.send(())
    }
    
    private func validateFirstContents(with indexPath: IndexPath) -> Bool {
        return (items.count == 3 && indexPath.row == 0)
    }
}

extension PopularRestaurantContentsItemView: Bindable {
    
    func bind(to viewModel: ViewModel) {        
        let input = ViewModel.Input(initialize: initialize.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.contentItems
            .receive(on: DispatchQueue.main)
            .sink {
                self.items = $0
                self.configureItems(items: $0)
            }.store(in: &cancellables)
    }
}

extension PopularRestaurantContentsItemView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = validateFirstContents(with: indexPath)
        ? bounds.width
        : Double(bounds.width / 2) - Double(Constants.cellLineSpcaing / 2)
        
        return CGSize(
            width: width,
            height: Double(Constants.cellHeight)
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(Constants.cellLineSpcaing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
