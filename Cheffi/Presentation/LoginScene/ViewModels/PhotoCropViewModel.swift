//
//  PhotoCropViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/13.
//

import Foundation
import Combine

protocol PhotoCropViewModelInput {
    func cropImage(cropRect: CGRect)
}

protocol PhotoCropViewModelOutput {
    var imageData: AnyPublisher<Data, Never> { get }
    var croppedImageData: AnyPublisher<Data?, Never> { get }
}

typealias PhotoCropViewModelType = PhotoCropViewModelInput & PhotoCropViewModelOutput

final class PhotoCropViewModel: PhotoCropViewModelType {
    private let _imageData: Data
    private let photoCropService: PhotoCropService
    
    // MARK: - Inputs
    func cropImage(cropRect: CGRect) {
        let croppedData = photoCropService.cropImageData(_imageData, in: cropRect)
        _croppedImageData.send(croppedData)
    }
    
    // MARK: - Outputs
    var imageData: AnyPublisher<Data, Never> {
        return Just(_imageData).eraseToAnyPublisher()
    }
    private let _croppedImageData = PassthroughSubject<Data?, Never>()
    var croppedImageData: AnyPublisher<Data?, Never> {
        return _croppedImageData.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(imageData: Data, service: PhotoCropService) {
        self._imageData = imageData
        self.photoCropService = service
    }
}
