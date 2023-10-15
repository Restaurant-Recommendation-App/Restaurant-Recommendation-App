//
//  FollowSelectionViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class FollowSelectionViewController: UIViewController {
    static func instance<T: FollowSelectionViewController>(viewModel: FollowSelectionViewModelType) -> T {
        let vc: T = .instance(storyboardName: .followSelection)
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet private weak var startButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: FollowSelectionViewModelType!
    
    private enum Constants {
        static let cellHeight: CGFloat = 104.0
    }
    
    private var dataSource: UITableViewDiffableDataSource<Int, RecommendFollowResponse>?
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.input.requestGetRecommendAvatars()
    }
    
    // MARK: - Private
    private func setupViews() {
        startButton.isEnable = true
        startButton.setTitle("시작하기".localized(), for: .normal)
        startButton.setBackgroundColor(.main)
        startButton.didTapButton = { [weak self] in
            self?.viewModel.input.requestPostRegisterUserProfile()
        }
        
        titleLabel.text = "같은 취향을 가진\n쉐피를 팔로우 해보세요.".localized()
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.weight600.size(24)
        
        subTitleLabel.text = "취향이 같은 쉐피들의 PICK을 확인해보세요!".localized()
        subTitleLabel.textColor = .cheffiGray6
        subTitleLabel.font = Fonts.suit.weight600.size(15)
        
        tableView.delegate = self
        tableView.register(nibWithCellClass: FollowSelectionCell.self)
        dataSource = UITableViewDiffableDataSource<Int, RecommendFollowResponse>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withClass: FollowSelectionCell.self, for: indexPath)
            cell.configrue(with: item) 
            cell.didTapFollowHandler = { [weak self] avatar, isSelected in
                self?.updateFollowingStatus(avatar: avatar, isSelected: isSelected)
            }
            return cell
        })
    }
    
    private func bindViewModel() {
        viewModel.output.recommendAvatars
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("---------------------------------------")
                    print(error)
                    print("---------------------------------------")
                }
            } receiveValue: { [weak self] avatars in
                self?.reload(with: avatars)
            }
            .store(in: &cancellables)
        
        viewModel.output.addAvatarFollow
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("---------------------------------------")
                    print(error)
                    print("---------------------------------------")
                }
            } receiveValue: { avata in
                print("\(avata?.nickname ?? "-") 팔로우 추가")
            }
            .store(in: &cancellables)
        
        viewModel.output.removeAvatarFollow
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("---------------------------------------")
                    print(error)
                    print("---------------------------------------")
                }
            } receiveValue: { avata in
                print("\(avata?.nickname ?? "-") 팔로우 삭제")
            }
            .store(in: &cancellables)
        
        viewModel.output.registerUserProfile
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.showAlert(title: "ERROR", message: error.localizedDescription) { [weak self] _ in
                        self?.delegate?.didTapNext(params: [:])
                    }
                }
            } receiveValue: { [weak self] results in
                if results.isEmpty == false {
                    print("---------------------------------------")
                    print("회원 등록 완료")
                    print(results)
                    print("---------------------------------------")
                    self?.delegate?.didTapNext(params: [:])
                }
            }
            .store(in: &cancellables)
    }
    
    private func showProfileList(_ avatars: [RecommendFollowResponse]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RecommendFollowResponse>()
        snapshot.appendSections([0])
        snapshot.appendItems(avatars, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func reload(with avatars: [RecommendFollowResponse]) {
        showProfileList(avatars)
    }
    
    private func updateFollowingStatus(avatar: RecommendFollowResponse?, isSelected: Bool) {
        guard let avatarId = avatar?.avatarId else { return }
        if isSelected {
            // 팔로우 등록
            viewModel.input.requestPostAvatarFollow(avatarId: avatarId)
        } else {
            // 팔로우 삭제
            viewModel.input.requestDeleteAvatarFollow(avatarId: avatarId)
        }
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
