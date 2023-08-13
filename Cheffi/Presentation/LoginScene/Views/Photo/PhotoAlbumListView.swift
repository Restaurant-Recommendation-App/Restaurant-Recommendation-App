//
//  PhotoAlbumListView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/13.
//

import UIKit

final class PhotoAlbumListView: BaseView {
    
    @IBOutlet private weak var tableView: UITableView!
    var didTapSelectedAlbumInfo: ((AlbumInfo) -> Void)?
    
    enum Constants {
        static let cellHeight: CGFloat = 86.0
    }
    
    private var dataSource: UITableViewDiffableDataSource<Int, AlbumInfo>? = nil
    
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
        tableView.delegate = self
        tableView.register(nibWithCellClass: PhotoAlbumListCell.self)
        dataSource = UITableViewDiffableDataSource<Int, AlbumInfo>(tableView: tableView, cellProvider: { tableView, indexPath, albumInfo in
            let cell = tableView.dequeueReusableCell(withClass: PhotoAlbumListCell.self, for: indexPath)
            cell.configre(with: albumInfo)
            return cell
        })
    }
    
    // MARK: - Public
    func showAlbumList(albumInfos: [AlbumInfo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AlbumInfo>()
        snapshot.appendSections([0])
        snapshot.appendItems(albumInfos, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


// MARK: - UITableViewDelegate
extension PhotoAlbumListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let albumInfo = dataSource?.itemIdentifier(for: indexPath) else { return }
        didTapSelectedAlbumInfo?(albumInfo)
    }
}
