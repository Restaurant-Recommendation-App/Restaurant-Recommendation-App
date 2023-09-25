//
//  FollowSelectionViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class FollowSelectionViewController: UIViewController {
    static func instance<T: FollowSelectionViewController>() -> T {
        let vc: T = .instance(storyboardName: .followSelection)
        return vc
    }
    
    @IBOutlet private weak var startButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    enum Constants {
        static let cellHeight: CGFloat = 104.0
    }
    
    private var dataSource: UITableViewDiffableDataSource<Int, String>?
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        startButton.setTitle("시작하기".localized(), for: .normal)
        startButton.setBackgroundColor(.main)
        startButton.didTapButton = { [weak self] in
            self?.delegate?.didTapNext()
        }
        
        titleLabel.text = "같은 취향을 가진\n쉐피를 팔로우 해보세요.".localized()
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.weight600.size(24)
        
        subTitleLabel.text = "취향이 같은 쉐피들의 PICK을 확인해보세요!".localized()
        subTitleLabel.textColor = .cheffiGray6
        subTitleLabel.font = Fonts.suit.weight600.size(15)
        
        tableView.delegate = self
        tableView.register(nibWithCellClass: FollowSelectionCell.self)
        dataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withClass: FollowSelectionCell.self, for: indexPath)
            cell.configrue(with: item)
            return cell
        })
        
        showProfileList(["김독자", "유중혁", "유상아", "이현성"])
    }
    
    private func showProfileList(_ nicknames: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(nicknames, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
}

// MARK: - UITableViewDelegate
extension FollowSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
