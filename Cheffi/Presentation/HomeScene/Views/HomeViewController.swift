//
//  ViewController.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    static func instance<T: HomeViewController>(viewModel: HomeViewModel) -> T {
        let vc: T = .instance(storyboardName: .home)
        vc.viewModel = viewModel
        return vc
    }
    
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
        tableView.register(cellWithClass: CheffiRecommendationCell.self)
        tableView.sectionHeaderTopPadding = 0
        tableView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Actions
    @IBAction private func didTapLocation(_ sender: UIButton) {
        // TODO: Test 코드
        viewModel.showPopup(text: "잠긴 게시물은\n회원가입 후 확인할 수 있어요!", keywrod: "회원가입 후 확인")
    }
    
    @IBAction private func didTapSearch(_ sender: UIButton) {
        viewModel.showSearch()
    }
    
    @IBAction private func didTapNotification(_ sender: UIButton) {
        // TODO: Test 코드
        viewModel.showPopup(text: "쉐피 코인 1개를 차감하여\n새로운 맛집을 찾아 떠나볼까요?", keywrod: "쉐피 코인 1개를 차감")
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
            cell.configure(viewModel: viewModel.popularRestaurantViewModel)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withClass: SimilarChefCell.self, for: indexPath)
            cell.configure(with: viewModel.similarChefViewModel)
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withClass: CheffiRecommendationCell.self, for: indexPath)
            cell.configure(viewModel: self.viewModel.recommendationViewModel)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 800
        case 1: return UITableView.automaticDimension
        case 2: return 700
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
}

// MARK: - SimilarChefCellDelegate
extension HomeViewController: SimilarChefCellDelegate {
    func didTapShowSimilarChefList() {
        viewModel.showSimilarChefList()
    }
}
