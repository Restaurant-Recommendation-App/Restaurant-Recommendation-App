//
//  PhotoCropViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/13.
//

import Foundation
import Combine

protocol PhotoCropViewModelInput {
    func setCroppedImageData(_ imageData: Data?)
}

protocol PhotoCropViewModelOutput {
    var imageData: Data { get }
    var croppedImageData: AnyPublisher<Data?, Never> { get }
}

typealias PhotoCropViewModelType = PhotoCropViewModelInput & PhotoCropViewModelOutput

final class PhotoCropViewModel: PhotoCropViewModelType {
    private let _imageData: Data
    
    // MARK: - Inputs
    func setCroppedImageData(_ imageData: Data?) {
        _croppedImageData.send(imageData)
    }
    
    // MARK: - Outputs
    var imageData: Data {
        return _imageData
    }
    private let _croppedImageData = PassthroughSubject<Data?, Never>()
    var croppedImageData: AnyPublisher<Data?, Never> {
        return _croppedImageData.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(imageData: Data) {
        self._imageData = imageData
    }
}
