//
//  LoginSceneFlowCoordinator.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit
import Combine

protocol LoginFlowCoordinatorDependencies: BaseFlowCoordinatorDependencies {
    func makeSNSLoginViewController(actions: SNSLoginViewModelActions) -> SNSLoginViewController
    func makeProfileSetupViewController(nicknameViewModel: NicknameViewModelType, profilePhotoViewModel: ProfilePhotoViewModelType) -> ProfileSetupViewController
    func makePhotoAlbumViewController() -> PhotoAlbumViewController
    func makeNicknameViewModel() -> NicknameViewModelType
    func makeProfilePhotoViewModel(actions: ProfilePhotoViewModelActions) -> ProfilePhotoViewModelType
}

final class LoginFlowCoordinator: BaseFlowCoordinator {
    private var loginDependencies: LoginFlowCoordinatorDependencies {
        return self.dependencies as! LoginFlowCoordinatorDependencies
    }
    
    deinit {
#if DEBUG
        print("LoginFlowCoordinator deinitialized")
#endif
    }
    
    func start() {
        let profileSetupActions = SNSLoginViewModelActions(showProfileSetup: showProfileSetupViewController)
        let vc = loginDependencies.makeSNSLoginViewController(actions: profileSetupActions)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Actions
    private func showProfileSetupViewController() {
        let profilePhotoActions = ProfilePhotoViewModelActions(showPhotoAlbum: showPhotoAlbumViewController)
        let vc = loginDependencies.makeProfileSetupViewController(nicknameViewModel: loginDependencies.makeNicknameViewModel(),
                                                                  profilePhotoViewModel: loginDependencies.makeProfilePhotoViewModel(actions: profilePhotoActions))
        self.navigationController?.pushViewController(vc)
    }
    
    private func showPhotoAlbumViewController() {
        let vc = loginDependencies.makePhotoAlbumViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
}
