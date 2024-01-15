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
    @IBOutlet weak var selectedAreaButton: UIButton!
    
    private let cheffiRecommendationHeader = CheffiRecommendationHeader()
    
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
        tableView.register(headerFooterViewClassWith: CheffiRecommendationHeader.self)
        tableView.backgroundColor = .cheffiWhite

        print("--------------------------------------------------")
        print("----------- user info")
        print(UserDefaultsManager.UserInfo.user)
        print("----------- session token")
        print(UserDefaultsManager.AuthInfo.sessionToken)
        print("--------------------------------------------------")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let area = UserDefaultsManager.AreaInfo.area.province + " " + UserDefaultsManager.AreaInfo.area.city
        selectedAreaButton.setTitle(area, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction private func didTapLocation(_ sender: UIButton) {
        // TODO: Test 코드
//        if (AccountManager.shared.isLogin) {
//            viewModel.showPopup(text: "쉐피 코인 1개를 차감하여\n새로운 맛집을 찾아 떠나볼까요?",
//                                subText: "",
//                                keywrod: "쉐피 코인 1개를 차감",
//                                popupState: .member(id: 1),
//                                leftButtonTitle: "취소하기",
//                                rightButtonTitle: "찾아보기")
//        } else {
//            viewModel.showPopup(text: "잠긴 게시물은\n회원가입 후 확인할 수 있어요!",
//                                subText: "",
//                                keywrod: "회원가입 후 확인",
//                                popupState: .nonMember,
//                                leftButtonTitle: "취소하기",
//                                rightButtonTitle: "찾아보기")
//        }
        viewModel.showAreaSelection()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withClass: PopularRestaurantCell.self, for: indexPath)
                cell.configure(viewModel: viewModel.popularRestaurantViewModel)
                cell.delegate = self
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withClass: SimilarChefCell.self, for: indexPath)
                cell.configure(with: viewModel.similarChefViewModel)
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withClass: CheffiRecommendationCell.self, for: indexPath)
            cell.configure(categoryPageViewDelegate: cheffiRecommendationHeader.categoryTabView)
            cheffiRecommendationHeader.configure(categoryTabViewDelegate: cell.cheffiRecommendationCatogoryPageView)
            
            cell.setUpTabNames = cheffiRecommendationHeader.setUpTabTitles
            cell.configure(viewModel: self.viewModel.recommendationViewModel)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return 800
            default: return UITableView.automaticDimension
            }
        case 1: return 522
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1: return cheffiRecommendationHeader
        default: return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1: return 148
        default: return Constants.headerHeight
        }
    }
}

// MARK: - SimilarChefCellDelegate
extension HomeViewController: SimilarChefCellDelegate {
    func didTapShowSimilarChefList() {
        viewModel.showSimilarChefList()
    }
}

extension HomeViewController: PopularRestaurantCellDelegate {
    func didTapShowAllContents() {
        viewModel.showAllContents()
    }
}
