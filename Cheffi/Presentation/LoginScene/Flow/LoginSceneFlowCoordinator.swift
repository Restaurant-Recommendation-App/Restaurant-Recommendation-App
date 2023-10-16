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
    func makeProfileSetupViewController(nicknameViewModel: NicknameViewModelType,
                                        profilePhotoViewModel: ProfilePhotoViewModelType,
                                        foodSelectionViewModel: FoodSelectionViewModelType,
                                        tasteSelectionViewModel: TasteSelectionViewModelType,
                                        followSelectionViewModel: FollowSelectionViewModelType
    ) -> ProfileSetupViewController
    func makeProfileImageSelectViewController(selectTypes: [ProfileImageSelectType],
                                              selectCompletion: ((ProfileImageSelectType) -> Void)?) -> ProfileImageSelectViewController
    func makePhotoAlbumViewController(viewModel: PhotoAlbumViewModel, dismissCompletion: ((Data?) -> Void)?) -> PhotoAlbumViewController
    func makePhotoAlbumViewModel(actions: PhotoAlbumViewModelActions) -> PhotoAlbumViewModel
    func makeNicknameViewModel() -> NicknameViewModelType
    func makeProfilePhotoViewModel(actions: ProfilePhotoViewModelActions) -> ProfilePhotoViewModelType
    func makePhotoCropViewController(viewModel: PhotoCropViewModel, dismissCompletion: ((Data?) -> Void)?) -> PhotoCropViewController
    func makePhotoCropViewModel(imageData: Data) -> PhotoCropViewModel
    func makeFoodSelectionViewModel() -> FoodSelectionViewModelType
    func makeTasteSelectionViewModel() -> TasteSelectionViewModelType
    func makeFollowSelectionViewModel() -> FollowSelectionViewModelType
}

final class LoginFlowCoordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    var dependencies: LoginFlowCoordinatorDependencies
    weak var profileSetupViewController: ProfileSetupViewController?
    var cameraService: DefaultCameraService?
    
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
        let profilePhotoActions = ProfilePhotoViewModelActions(showCamera: showCameraViewController,
                                                               showPhotoCrop: showPhotoCropViewController,
                                                               showPhotoAlbum: showPhotoAlbumViewController,
                                                               showProfileImageSelect: showProfileImageSelectViewController)
        let vc = dependencies.makeProfileSetupViewController(nicknameViewModel: dependencies.makeNicknameViewModel(),
                                                             profilePhotoViewModel: dependencies.makeProfilePhotoViewModel(actions: profilePhotoActions), foodSelectionViewModel: dependencies.makeFoodSelectionViewModel(),
                                                             tasteSelectionViewModel: dependencies.makeTasteSelectionViewModel(),
                                                             followSelectionViewModel: dependencies.makeFollowSelectionViewModel())
        self.profileSetupViewController = vc
        self.navigationController?.pushViewController(vc)
    }
    
    private func showPhotoAlbumViewController(dismissCompletion: ((Data?) -> Void)?) {
        let actions = PhotoAlbumViewModelActions(showPhotoCrop: showPhotoCropViewController,
                                                 showCamera: showCameraViewController)
        let viewModel = dependencies.makePhotoAlbumViewModel(actions: actions)
        viewModel.checkPhotoPermission { [weak self] isPermission in
            DispatchQueue.main.async {
                if isPermission {
                    let vc = self?.dependencies.makePhotoAlbumViewController(viewModel: viewModel, dismissCompletion: dismissCompletion)
                    self?.navigationController?.present(vc!, animated: true)
                }
            }
        }
    }
    
    private func showProfileImageSelectViewController(selectTypes: [ProfileImageSelectType], selectTypeCompletion: ((ProfileImageSelectType) -> Void)?) {
        let vc = dependencies.makeProfileImageSelectViewController(selectTypes: selectTypes, selectCompletion: selectTypeCompletion)
        self.navigationController?.present(vc, animated: true)
    }
    
    private func showCameraViewController(isPresentPhotoAlbum: Bool, dismissCompletion: ((Data?) -> Void)?) {
#if DEBUG
        print("---------->>> show camera")
#endif
        cameraService = nil
        cameraService = DefaultCameraService()
        if isPresentPhotoAlbum {
            guard let vc = self.navigationController?.findPresentedViewController(ofType: PhotoAlbumViewController.self) else { return }
            cameraService?.captureImage(from: vc) { captureImage in
                dismissCompletion?(captureImage?.pngData())
            }
        } else {
            guard let vc = self.navigationController else { return }
            cameraService?.captureImage(from: vc) { captureImage in
                dismissCompletion?(captureImage?.pngData())
            }
        }
    }
    
    private func showPhotoCropViewController(imageData: Data, dismissCompletion: ((Data?) -> Void)?) {
        let viewModel = dependencies.makePhotoCropViewModel(imageData: imageData)
        let vc = dependencies.makePhotoCropViewController(viewModel: viewModel, dismissCompletion: dismissCompletion)
        if let photoalbumVC = self.navigationController?.findPresentedViewController(ofType: PhotoAlbumViewController.self) {
            photoalbumVC.present(vc, animated: true)
        } else {
            self.navigationController?.present(vc, animated: true)
        }
    }
}
