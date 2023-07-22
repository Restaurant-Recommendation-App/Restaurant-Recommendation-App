//
//  ViewController.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {
    
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: HomeViewModel!
    
    enum Constants {
        static let headerHeight: CGFloat = 32.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: SimilarChefCell.self)
        tableView.register(cellWithClass: PopularRestaurantCell.self)
        tableView.sectionHeaderTopPadding = 0
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withClass: PopularRestaurantCell.self, for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withClass: SimilarChefCell.self, for: indexPath)
            cell.configure(with: viewModel.similarChefViewModel)
            return cell
        case 2:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 800
        case 1: return 485
        case 2: return 500
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}

