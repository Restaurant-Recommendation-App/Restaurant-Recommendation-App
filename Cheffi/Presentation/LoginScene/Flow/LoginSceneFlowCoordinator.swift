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
    func makePhotoAlbumViewController(actions: PhotoAlbumViewModelActions, dismissCompltion: ((Data?) -> Void)?) -> PhotoAlbumViewController
    func makeNicknameViewModel() -> NicknameViewModelType
    func makeProfilePhotoViewModel(actions: ProfilePhotoViewModelActions) -> ProfilePhotoViewModelType
    func makePhotoCropViewController(viewModel: PhotoCropViewModel, dismissCompltion: ((Data?) -> Void)?) -> PhotoCropViewController
    func makePhotoCropViewModel(imageData: Data) -> PhotoCropViewModel
}

final class LoginFlowCoordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    var dependencies: LoginFlowCoordinatorDependencies
    weak var profileSetupViewController: ProfileSetupViewController?
    
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
        self.profileSetupViewController = vc
        self.navigationController?.pushViewController(vc)
    }
    
    private func showPhotoAlbumViewController(dismissCompltion: ((Data?) -> Void)?) {
        let actions = PhotoAlbumViewModelActions(showPhotoCrop: showPhotoCropViewController)
        let vc = dependencies.makePhotoAlbumViewController(actions: actions, dismissCompltion: dismissCompltion)
        vc.modalPresentationStyle = .overFullScreen
        self.profileSetupViewController?.present(vc, animated: true)
    }
    
    private func showCameraViewController() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            // 카메라를 사용할 수 없는 경우 처리
            return
        }
    }
    
    private func showPhotoCropViewController(imageData: Data, dismissCompltion: ((Data?) -> Void)?) {
        let viewModel = dependencies.makePhotoCropViewModel(imageData: imageData)
        let vc = dependencies.makePhotoCropViewController(viewModel: viewModel, dismissCompltion: dismissCompltion)
        vc.modalPresentationStyle = .overCurrentContext
        self.profileSetupViewController?.presentedViewController?.present(vc, animated: true)
    }
}
