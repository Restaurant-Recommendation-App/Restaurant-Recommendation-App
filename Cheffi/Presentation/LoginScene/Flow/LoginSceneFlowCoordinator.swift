//
//  LoginSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit
import Combine

protocol LoginFlowCoordinatorDependencies {
    func makeSNSLoginViewController(actions: SNSLoginViewModelActions) -> SNSLoginViewController
    func makeProfileSetupViewController(nicknameViewModel: NicknameViewModelType, profilePhotoViewModel: ProfilePhotoViewModelType) -> ProfileSetupViewController
    func makePhotoAlbumViewController() -> PhotoAlbumViewController
    func makeNicknameViewModel() -> NicknameViewModelType
    func makeProfilePhotoViewModel(actions: ProfilePhotoViewModelActions) -> ProfilePhotoViewModelType
}

final class LoginFlowCoordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    var dependencies: LoginFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController?, parentCoordinator: AppFlowCoordinator?, dependencies: LoginFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    deinit {
#if DEBUG
        print("LoginFlowCoordinator deinitialized")
#endif
    }
    
    func start() {
        let profileSetupActions = SNSLoginViewModelActions(showProfileSetup: showProfileSetupViewController)
        let vc = dependencies.makeSNSLoginViewController(actions: profileSetupActions)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Actions
    private func showProfileSetupViewController() {
        let profilePhotoActions = ProfilePhotoViewModelActions(showPhotoAlbum: showPhotoAlbumViewController)
        let vc = dependencies.makeProfileSetupViewController(nicknameViewModel: dependencies.makeNicknameViewModel(),
                                                                  profilePhotoViewModel: dependencies.makeProfilePhotoViewModel(actions: profilePhotoActions))
        self.navigationController?.pushViewController(vc)
    }
    
    private func showPhotoAlbumViewController() {
        let vc = dependencies.makePhotoAlbumViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    private func showCameraViewController() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            // 카메라를 사용할 수 없는 경우 처리
            return
        }
    }
}
