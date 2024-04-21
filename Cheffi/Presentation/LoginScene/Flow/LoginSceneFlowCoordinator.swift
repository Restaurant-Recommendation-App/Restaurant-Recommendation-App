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
    func makeAgreementViewController(reducer: AgreementReducer) -> AgreementViewContrroller
    func makeAgreementReducer(steps: PassthroughSubject<RouteStep, Never>) -> AgreementReducer
    func makeUserRegistComplViewController(reducer: UserRegistComplReducer) -> UserRegistCompletionViewController
    func makeUserRegistComplReducer(steps: PassthroughSubject<RouteStep, Never>) -> UserRegistComplReducer
    func makeProfileSetupViewController(nicknameViewModel: NicknameViewModelType,
                                        profilePhotoViewModel: ProfilePhotoViewModelType,
                                        foodSelectionViewModel: FoodSelectionViewModelType,
                                        tasteSelectionViewModel: TasteSelectionViewModelType,
                                        profileRegistComplReducer: ProfileRegistCompleReducer
    ) -> ProfileSetupViewController
    func makeProfileImageSelectViewController(selectTypes: [ProfileImageSelectType],
                                              selectCompletion: ((ProfileImageSelectType) -> Void)?) -> ProfileImageSelectViewController
    func makePhotoAlbumViewController(viewModel: PhotoAlbumViewModel, dismissCompletion: (([Data?]) -> Void)?) -> PhotoAlbumViewController
    func makePhotoAlbumViewModel(actions: PhotoAlbumViewModelActions) -> PhotoAlbumViewModel
    func makeNicknameViewModel() -> NicknameViewModelType
    func makeProfilePhotoViewModel(actions: ProfilePhotoViewModelActions) -> ProfilePhotoViewModelType
    func makePhotoCropViewController(viewModel: PhotoCropViewModel, dismissCompletion: ((Data?) -> Void)?) -> PhotoCropViewController
    func makePhotoCropViewModel(imageData: Data) -> PhotoCropViewModel
    func makeFoodSelectionViewModel() -> FoodSelectionViewModelType
    func makeTasteSelectionViewModel() -> TasteSelectionViewModelType
    func makeProfileRegistComplReducer(steps: PassthroughSubject<RouteStep, Never>) -> ProfileRegistCompleReducer
}

final class LoginFlowCoordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    weak var profileSetupViewController: ProfileSetupViewController?
    
    private let steps = PassthroughSubject<RouteStep, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var dependencies: LoginFlowCoordinatorDependencies
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
        let snsLoginViewAction = SNSLoginViewModelActions(showProfileSetup: pushAgreementVC)
        let vc = dependencies.makeSNSLoginViewController(actions: snsLoginViewAction)
        self.navigationController?.pushViewController(vc, animated: true)
        
        steps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                guard let self else { return }
                switch step {
                case .pushAgreementViewController:
                    pushAgreementVC()
                case .pushUserRegistComplViewController:
                    pushUserRegistComplVC()
                case .pushProfileSetupViewController:
                    pushProfileSetupVC()
                case .popToNavigationController:
                    popToRootViewController()
                case .dismissTermsView:
                    dismissTermsView()
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    private func pushAgreementVC() {
        let reducer = dependencies.makeAgreementReducer(steps: steps)
        let vc = dependencies.makeAgreementViewController(reducer: reducer)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushUserRegistComplVC() {
        let reducer = dependencies.makeUserRegistComplReducer(steps: steps)
        let vc  = dependencies.makeUserRegistComplViewController(reducer: reducer)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushProfileSetupVC() {
        showProfileSetupViewController()
    }
    
    private func popToRootViewController() {
        self.navigationController?.dismiss(animated: true) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func dismissTermsView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showProfileSetupViewController() {
        let profilePhotoActions = ProfilePhotoViewModelActions(showCamera: showCameraViewController,
                                                               showPhotoCrop: showPhotoCropViewController,
                                                               showPhotoAlbum: showPhotoAlbumViewController,
                                                               showProfileImageSelect: showProfileImageSelectViewController)
        let vc = dependencies.makeProfileSetupViewController(nicknameViewModel: dependencies.makeNicknameViewModel(),
                                                             profilePhotoViewModel: dependencies.makeProfilePhotoViewModel(actions: profilePhotoActions),
                                                             foodSelectionViewModel: dependencies.makeFoodSelectionViewModel(),
                                                             tasteSelectionViewModel: dependencies.makeTasteSelectionViewModel(),
                                                             profileRegistComplReducer: dependencies.makeProfileRegistComplReducer(steps: steps))
        self.profileSetupViewController = vc
        self.navigationController?.pushViewController(vc)
    }
    
    private func showPhotoAlbumViewController(dismissCompletion: (([Data?]) -> Void)?) {
        let actions = PhotoAlbumViewModelActions(showPhotoCrop: showPhotoCropViewController,
                                                 showCamera: showCameraViewController)
        let viewModel = dependencies.makePhotoAlbumViewModel(actions: actions)
        viewModel.multiSelectionEnable = false
        viewModel.checkPhotoPermission { [weak self] isPermission in
            DispatchQueue.main.async {
                if isPermission {
                    let vc = self?.dependencies.makePhotoAlbumViewController(viewModel: viewModel, dismissCompletion: dismissCompletion)
                    self?.navigationController?.present(vc!, animated: true)
                }
            }
        }
    }
    
    func showPhotoAlbumWithoutPhotoCrop(dismissCompletion: (([Data?]) -> Void)?) {
        let actions = PhotoAlbumViewModelActions(showPhotoCrop: nil,
                                                 showCamera: showCameraViewController)
        let viewModel = dependencies.makePhotoAlbumViewModel(actions: actions)
        viewModel.multiSelectionEnable = true
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
    
    func showCameraViewController(isPresentPhotoAlbum: Bool, dismissCompletion: ((Data?) -> Void)?) {
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
