//
//  LoginSceneDIContainer.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import UIKit


final class LoginSceneDIContainer: LoginFlowCoordinatorDependencies {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
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
        let repository = makeAuthRepository()
        let useCase = makeAuthUseCase(repository: repository)
        return SNSLoginViewModel(actions: actions,
                                 useCase: useCase)
    }
    
    // MARK: - ProfileSetup
    func makeProfileSetupViewController(nicknameViewModel: NicknameViewModelType, profilePhotoViewModel: ProfilePhotoViewModelType) -> ProfileSetupViewController {
        let viewModel = makeProfileSetupViewModel()
        return ProfileSetupViewController.instance(viewModel: viewModel,
                                                   nicknameViewController: makeNicknameViewController(),
                                                   profilePhotoViewController: makeProfilePhotoViewController(viewMoel: profilePhotoViewModel),
                                                   foodSelectionViewController: makeFoodSelectionViewController(),
                                                   tasteSelectionViewController: makeTasteSelectionViewController(),
                                                   followSelectionViewController: makeFollowSelectionViewController())
    }
    
    // MARK: - Nickname
    func makeNicknameViewController() -> NicknameViewController {
        let viewModel = makeNicknameViewModel()
        let vc = NicknameViewController.instance(viewMode: viewModel)
        return vc
    }
    
    func makeNicknameViewModel() -> NicknameViewModelType {
        let repository = makeAuthRepository()
        let useCase = makeAuthUseCase(repository: repository)
        return NicknameViewModel(useCase: useCase)
    }
    
    // MARK: - ProfilePhoto
    func makeProfilePhotoViewController(viewMoel: ProfilePhotoViewModelType) -> ProfilePhotoViewController {
        return ProfilePhotoViewController.instance(viewModel: viewMoel)
    }
    
    func makeProfilePhotoViewModel(actions: ProfilePhotoViewModelActions) -> ProfilePhotoViewModelType {
        return ProfilePhotoViewModel(actions: actions,
                                     photoUseCase: makePhotoUseCase(),
                                     cameraService: makeCameraService())
    }
    
    // MARK: - FoodSelection
    func makeFoodSelectionViewController() -> FoodSelectionViewController {
        return FoodSelectionViewController.instance()
    }
    
    // MARK: - Taste
    func makeTasteSelectionViewController() -> TasteSelectionViewController {
        return TasteSelectionViewController.instance()
    }
    
    // MARK: - FollowSelection
    func makeFollowSelectionViewController() -> FollowSelectionViewController {
        return FollowSelectionViewController.instance()
    }
    
    func makeProfileSetupViewModel() -> ProfileSetupViewModel {
        return ProfileSetupViewModel()
    }
    
    // MARK: - ProfileImageSelectViewController
    func makeProfileImageSelectViewController(selectTypes: [ProfileImageSelectType], selectCompletion: ((ProfileImageSelectType) -> Void)?) -> ProfileImageSelectViewController {
        return ProfileImageSelectViewController.instance(selectTypes: selectTypes, selectCompletion: selectCompletion)
    }
    
    // MARK: - Photo Album
    func makePhotoAlbumViewController(viewModel: PhotoAlbumViewModel, dismissCompletion: ((Data?) -> Void)?) -> PhotoAlbumViewController {
        return PhotoAlbumViewController.instance(viewModel: viewModel, dismissCompletion: dismissCompletion)
    }
    
    func makePhotoAlbumViewModel(actions: PhotoAlbumViewModelActions) -> PhotoAlbumViewModel {
        return PhotoAlbumViewModel(actions: actions,
                                    photoUseCase: makePhotoUseCase(),
                                   cameraService: makeCameraService())
    }
    
    func makeCameraService() -> DefaultCameraService {
        return DefaultCameraService()
    }
    
    // MARK: - Photo Crop
    func makePhotoCropViewController(viewModel: PhotoCropViewModel, dismissCompletion: ((Data?) -> Void)?) -> PhotoCropViewController {
        return PhotoCropViewController.instance(viewModel: viewModel, dismissCompletion: dismissCompletion)
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

// MARK: -  UseCase
extension LoginSceneDIContainer {
    func makePhotoUseCase() -> DefaultPhotoUseCase {
        return DefaultPhotoUseCase(repository: makePhotoRepository())
    }
    
    func makeAuthUseCase(repository: AuthRepository) -> AuthUseCase {
        return DefaultAuthUserCase(repository: repository)
    }
}

// MARK: - Repository
extension LoginSceneDIContainer {
    func makePhotoRepository() -> DefaultPhotoRepository {
        return DefaultPhotoRepository()
    }
    
    func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}
