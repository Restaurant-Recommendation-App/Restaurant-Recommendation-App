//
//  SearchViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    static func instance<T: SearchViewController>(viewModel: SearchViewModel) -> T {
        let vc: T = .instance(storyboardName: .search)
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: SearchViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: RecentSearchCell.self)
        tableView.register(nibWithCellClass: RecommendSearchCell.self)
        tableView.register(nibWithCellClass: TopPickCell.self)
        
        viewModel.loadInitialData()
    }
    
    private func bindView() {
        viewModel.recentSearches
            .sink { [weak self] recentSearches in
                
            }
            .store(in: &cancellables)
        viewModel.recommendSearches
            .sink { [weak self] recommendSearches in
            }
            .store(in: &cancellables)
        
        viewModel.topPicks
            .sink { [weak self] topPicks in
                // Update your UI here with the top picks
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @IBAction private func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: -
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SearchType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let searchType = SearchType(rawValue: indexPath.section) else { return UITableViewCell() }
        switch searchType {
        case .recent:
            let cell = tableView.dequeueReusableCell(withClass: RecentSearchCell.self, for: indexPath)
            return cell
        case .recommend:
            let cell = tableView.dequeueReusableCell(withClass: RecommendSearchCell.self, for: indexPath)
            return cell
        case .topPick:
            let cell = tableView.dequeueReusableCell(withClass: TopPickCell.self, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let searchType = SearchType(rawValue: indexPath.section) else { return 0.0 }
        switch searchType {
        case .recent: return 100
        case .recommend: return 100
        case .topPick: return 100
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let searchType = SearchType(rawValue: section) else { return nil }
        switch searchType {
        case .recent: return "최근 검색어".localized()
        case .recommend: return "추천 검색어".localized()
        case .topPick: return "지금 쉐피들의 PICK".localized()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
}
