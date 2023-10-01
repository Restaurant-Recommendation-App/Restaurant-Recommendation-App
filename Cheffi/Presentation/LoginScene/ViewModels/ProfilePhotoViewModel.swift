//
//  ProfilePhotoViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/09.
//

import Foundation
import Combine

struct ProfilePhotoViewModelActions {
    let showCamera: (_ isPresentPhotoAlbum: Bool, _ dismissCompletion: ((Data?) -> Void)?) -> Void
    let showPhotoCrop: (_ imageData: Data, _ dismissCompletion: ((Data?) -> Void)?) -> Void
    let showPhotoAlbum: (_ dismissCompletion: ((Data?) -> Void)?) -> Void
    let showProfileImageSelect: (_ selectTypes: [ProfileImageSelectType], _ selectTypeCompletion: ((ProfileImageSelectType) -> Void)?) -> Void
}

protocol ProfilePhotoViewModelInput {
}

protocol ProfilePhotoViewModelOutput {
    func showCamera(_ isPresentPhotoAlbum: Bool, _ dismissCompletion: ((Data?) -> Void)?)
    func showPhotoCrop(_ captureImageData: Data?, _ dismissCompletion: ((Data?) -> Void)?)
    func showPhotoAlbum(_ dismissCompletion: ((Data?) -> Void)?)
    func showProfileImageSelect(_ selectTypes: [ProfileImageSelectType], _ selectTypeCompletion: ((ProfileImageSelectType) -> Void)?)
}

typealias ProfilePhotoViewModelType = ProfilePhotoViewModelInput & ProfilePhotoViewModelOutput

final class ProfilePhotoViewModel: ProfilePhotoViewModelType {
    // MARK: - Input
    // MARK: - Output
    func showCamera(_ isPresentPhotoAlbum: Bool, _ dismissCompletion: ((Data?) -> Void)?) {
        actions.showCamera(isPresentPhotoAlbum, dismissCompletion)
    }
    
    func showPhotoCrop(_ captureImageData: Data?, _ dismissCompletion: ((Data?) -> Void)?) {
        if let imageData = captureImageData {
            actions.showPhotoCrop(imageData, dismissCompletion)
        }
    }
    
    func showPhotoAlbum(_ dismissCompletion: ((Data?) -> Void)?) {
        actions.showPhotoAlbum(dismissCompletion)
    }
    
    func showProfileImageSelect(_ selectTypes: [ProfileImageSelectType], _ selectTypeCompletion: ((ProfileImageSelectType) -> Void)?) {
        actions.showProfileImageSelect(selectTypes, selectTypeCompletion)
    }
    
    // MARK: - Init
    private var cancellables: Set<AnyCancellable> = []
    private let actions: ProfilePhotoViewModelActions
    private let photoUseCase: PhotoUseCase
    private let cameraService: CameraService
    init(actions: ProfilePhotoViewModelActions,
         photoUseCase: PhotoUseCase,
         cameraService: CameraService) {
        self.actions = actions
        self.photoUseCase = photoUseCase
        self.cameraService = cameraService
    }
}
