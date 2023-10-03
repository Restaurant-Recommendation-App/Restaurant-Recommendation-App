//
//  LoginSceneDIContainer.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit


final class LoginSceneDIContainer: LoginFlowCoordinatorDependencies {
    func makeLoginFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> LoginFlowCoordinator {
        return LoginFlowCoordinator(navigationController: navigationController,
                                    parentCoordinator: parentCoordinator,
                                    dependencies: self)
    }
    
    // MARK: - SNS Login
    func makeSNSLoginViewController(actions: SNSLoginViewModelActions) -> SNSLoginViewController {
        let viewModel = makeSNSLoginViewModel(actions: actions)
        let vc = SNSLoginViewController.instance(viewModel: viewModel)
        return vc
    }
    
    func makeSNSLoginViewModel(actions: SNSLoginViewModelActions) -> SNSLoginViewModel {
        return SNSLoginViewModel(actions: actions)
    }
    
    // MARK: - ProfileSetup
    func makeProfileSetupViewController(nicknameViewModel: NicknameViewModelType, profilePhotoViewModel: ProfilePhotoViewModelType) -> ProfileSetupViewController {
        let viewModel = makeProfileSetupViewModel()
        return ProfileSetupViewController.instance(viewModel: viewModel,
                                                   nicknameViewController: makeNicknameViewController(),
                                                   profilePhotoViewController: makeProfilePhotoViewController(viewMoel: profilePhotoViewModel),
                                                   foodSelectionViewController: makeFoodSelectionViewController(),
                                                   preferenceViewController: makePreferenceViewController(),
                                                   followSelectionViewController: makeFollowSelectionViewController())
    }
    
    // MARK: - Nickname
    func makeNicknameViewController() -> NicknameViewController {
        let viewModel = makeNicknameViewModel()
        let vc = NicknameViewController.instance(viewMode: viewModel)
        return vc
    }
    
    func makeNicknameViewModel() -> NicknameViewModelType {
        return NicknameViewModel()
    }
    
    // MARK: - ProfilePhoto
    func makeProfilePhotoViewController(viewMoel: ProfilePhotoViewModelType) -> ProfilePhotoViewController {
        return ProfilePhotoViewController.instance(viewModel: viewMoel)
    }
    
    func makeProfilePhotoViewModel(actions: ProfilePhotoViewModelActions) -> ProfilePhotoViewModelType {
        return ProfilePhotoViewModel(actions: actions)
    }
    
    // MARK: - FoodSelection
    func makeFoodSelectionViewController() -> FoodSelectionViewController {
        return FoodSelectionViewController.instance()
    }
    
    // MARK: - Preference
    func makePreferenceViewController() -> PreferenceViewController {
        return PreferenceViewController.instance()
    }
    
    // MARK: - FollowSelection
    func makeFollowSelectionViewController() -> FollowSelectionViewController {
        return FollowSelectionViewController.instance()
    }
    
    func makeProfileSetupViewModel() -> ProfileSetupViewModel {
        return ProfileSetupViewModel()
    }
    
    // MARK: - Photo Album
    func makePhotoAlbumViewController(actions: PhotoAlbumViewModelActions, dismissCompltion: ((Data?) -> Void)?) -> PhotoAlbumViewController {
        let viewModel = makePhotoAlbumViewModel(actions: actions)
        return PhotoAlbumViewController.instance(viewModel: viewModel, dismissCompltion: dismissCompltion)
    }
    
    func makePhotoAlbumViewModel(actions: PhotoAlbumViewModelActions) -> PhotoAlbumViewModel {
        return PhotoAlbumViewModel(actions: actions,
                                    photoUseCase: makePhotoUseCase(),
                                   cameraService: makeCameraService())
    }
    
    func makePhotoRepository() -> DefaultPhotoRepository {
        return DefaultPhotoRepository()
    }
    
    func makePhotoUseCase() -> DefaultPhotoUseCase {
        return DefaultPhotoUseCase(repository: makePhotoRepository())
    }
    
    func makeCameraService() -> DefaultCameraService {
        return DefaultCameraService()
    }
    
    // MARK: - Photo Crop
    func makePhotoCropViewController(viewModel: PhotoCropViewModel, dismissCompltion: ((Data?) -> Void)?) -> PhotoCropViewController {
        return PhotoCropViewController.instance(viewModel: viewModel, dismissCompltion: dismissCompltion)
    }
    
    func makePhotoCropViewModel(imageData: Data) -> PhotoCropViewModel {
        return PhotoCropViewModel(imageData: imageData)
    }
    
    // MAKR: - PopupViewController
    func makePopupViewController(text: String, subText: String, keyword: String, popupState: PopupState, leftButtonTitle: String, rightButtonTitle: String, leftHandler: (() -> Void)?, rightHandler: (() -> Void)?) -> PopupViewController {
        return PopupViewController.instance(text: text,
                                            subText: subText,
                                            keyword: keyword,
                                            popupState: popupState,
                                            leftButtonTitle: leftButtonTitle,
                                            rightButtonTitle: rightButtonTitle,
                                            leftHandler: leftHandler,
                                            rightHandler: rightHandler)
    }
}
