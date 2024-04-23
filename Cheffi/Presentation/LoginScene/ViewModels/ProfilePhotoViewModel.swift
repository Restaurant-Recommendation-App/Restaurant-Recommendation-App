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
    let showPhotoAlbum: (_ dismissCompletion: (([Data?]) -> Void)?) -> Void
    let showProfileImageSelect: (_ selectTypes: [ProfileImageSelectType], _ selectTypeCompletion: ((ProfileImageSelectType) -> Void)?) -> Void
}

protocol ProfilePhotoViewModelInput {
    func setPlaceHolder(_ text: String)
    func setImageData(imageData: Data)
    func setIntroduction(_ text: String)
    func postPhostosDidTap()
}

protocol ProfilePhotoViewModelOutput {
    var responsePostPhotos: AnyPublisher<String?, DataTransferError> { get }
    func showCamera(_ isPresentPhotoAlbum: Bool, _ dismissCompletion: ((Data?) -> Void)?)
    func showPhotoCrop(_ captureImageData: Data?, _ dismissCompletion: ((Data?) -> Void)?)
    func showPhotoAlbum(_ dismissCompletion: (([Data?]) -> Void)?)
    func showProfileImageSelect(_ selectTypes: [ProfileImageSelectType], _ selectTypeCompletion: ((ProfileImageSelectType) -> Void)?)
}

protocol ProfilePhotoViewModelType {
    var input: ProfilePhotoViewModelInput { get }
    var output: ProfilePhotoViewModelOutput { get }
    var isPhotoSelected: Bool { get set }
}

final class ProfilePhotoViewModel: ProfilePhotoViewModelType {
    var input: ProfilePhotoViewModelInput { return self }
    var output: ProfilePhotoViewModelOutput { return self }
    var isPhotoSelected: Bool = false
    
    private var _placeHolder: String = ""
    private var _imageData: Data = Data()
    private var _introduction: String = ""
    
    private var requestPostPhotosSubject = PassthroughSubject<(Data, ChangeProfilePhotoRequest), Never>()
    
    // MARK: - Init
    private var cancellables: Set<AnyCancellable> = []
    private let actions: ProfilePhotoViewModelActions
    private let useCase: PhotoUseCase
    private let cameraService: CameraService
    init(actions: ProfilePhotoViewModelActions,
         photoUseCase: PhotoUseCase,
         cameraService: CameraService) {
        self.actions = actions
        self.useCase = photoUseCase
        self.cameraService = cameraService
    }
    
    // MARK: - Private
    private func requestPostPhotos(imageData: Data, changeProfilePhotoRequest: ChangeProfilePhotoRequest) -> AnyPublisher<String?, DataTransferError> {
        let subject = PassthroughSubject<String?, DataTransferError>()
        useCase.postPhotos(imageData: imageData, changeProfilePhotoRequest: changeProfilePhotoRequest)
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { imageDataString, _ in
                subject.send(imageDataString)
            }
            .store(in: &cancellables)

        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Input
extension ProfilePhotoViewModel: ProfilePhotoViewModelInput {
    func setPlaceHolder(_ text: String) {
        _placeHolder = text
    }
    
    func setImageData(imageData: Data) {
        _imageData = imageData
    }
    
    func setIntroduction(_ text: String) {
        _introduction = text
    }
    
    func postPhostosDidTap() {
        let changeProfilePhotoRequest: ChangeProfilePhotoRequest
        
        if _introduction == _placeHolder {
            changeProfilePhotoRequest = ChangeProfilePhotoRequest(defaults: false, introduction: "1234567890")
        } else {
            changeProfilePhotoRequest = ChangeProfilePhotoRequest(defaults: false, introduction: _introduction)
        }
        
        requestPostPhotosSubject.send((self._imageData, changeProfilePhotoRequest))
    }
}

// MARK: - Output
extension ProfilePhotoViewModel: ProfilePhotoViewModelOutput {
    var responsePostPhotos: AnyPublisher<String?, DataTransferError> {
        return requestPostPhotosSubject
            .flatMap { [weak self] imageData, changeProfilePhotoRequest -> AnyPublisher<String?, DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success(nil))
                    }.eraseToAnyPublisher()
                }
                return self.requestPostPhotos(imageData: imageData, changeProfilePhotoRequest: changeProfilePhotoRequest)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func showCamera(_ isPresentPhotoAlbum: Bool, _ dismissCompletion: ((Data?) -> Void)?) {
        actions.showCamera(isPresentPhotoAlbum, dismissCompletion)
    }
    
    func showPhotoCrop(_ captureImageData: Data?, _ dismissCompletion: ((Data?) -> Void)?) {
        if let imageData = captureImageData {
            actions.showPhotoCrop(imageData, dismissCompletion)
        }
    }
    
    func showPhotoAlbum(_ dismissCompletion: (([Data?]) -> Void)?) {
        actions.showPhotoAlbum(dismissCompletion)
    }
    
    func showProfileImageSelect(_ selectTypes: [ProfileImageSelectType], _ selectTypeCompletion: ((ProfileImageSelectType) -> Void)?) {
        actions.showProfileImageSelect(selectTypes, selectTypeCompletion)
    }
}
