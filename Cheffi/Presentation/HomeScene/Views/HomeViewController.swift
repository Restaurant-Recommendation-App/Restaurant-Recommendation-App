//
//  ViewController.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/14.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    static func instance<T: HomeViewController>(viewModel: HomeViewModelType) -> T {
        let vc: T = .instance(storyboardName: .home)
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: HomeViewModelType!
    
    private enum Constants {
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
        
        print("--------------------------------------------------")
        print("user info")
        print(UserDefaultsManager.AuthInfo.user)
        print("--------------------------------------------------")
    }
    
    // MARK: - Actions
    @IBAction private func didTapLocation(_ sender: UIButton) {
        // TODO: Test 코드
        viewModel.showPopup(text: "잠긴 게시물은\n회원가입 후 확인할 수 있어요!",
                            subText: "",
                            keywrod: "회원가입 후 확인",
                            popupState: .nonMember,
                            leftButtonTitle: "취소하기",
                            rightButtonTitle: "찾아보기")
    }
    
    @IBAction private func didTapSearch(_ sender: UIButton) {
        viewModel.showSearch()
    }
    
    @IBAction private func didTapNotification(_ sender: UIButton) {
        viewModel.showNotification()
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
        case 2: return 670
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
