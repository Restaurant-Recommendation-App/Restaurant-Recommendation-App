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
    func makePhotoAlbumViewController() -> PhotoAlbumViewController {
        let viewModel = makePhotoAlbumViewModel()
        return PhotoAlbumViewController.instance(viewModel: viewModel)
    }
    
    func makePhotoAlbumViewModel() -> PhotoAlbumViewModel {
        return PhotoAlbumViewModel(photoUseCase: makeFetchPhotoUseCase())
    }
    
    // MAKR: - PopupViewController
    func makePopupViewController(text: String, keyword: String, findHandler: (() -> Void)?, cancelHandler: (() -> Void)?) -> PopupViewController {
        return PopupViewController.instance(text: text, keyword: keyword, findHandler: findHandler, cancelHandler: cancelHandler)
    }
}

// MARK: - Use Cases
extension LoginSceneDIContainer {
    func makeFetchPhotoUseCase() -> DefaultFetchPhotoUseCase {
        return DefaultFetchPhotoUseCase()
    }
}
