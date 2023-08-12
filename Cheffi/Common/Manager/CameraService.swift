//
//  CameraService.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/12.
//

import UIKit
import Combine

protocol CameraService {
    func captureImage() -> AnyPublisher<CapturedImage?, Never>
}

final class DefaultCameraService: CameraService {
    private var imagePickerDelegate: ImagePickerDelegate?
    
    func captureImage() -> AnyPublisher<CapturedImage?, Never> {
        let imagePickerDelegate = ImagePickerDelegate()
        self.imagePickerDelegate = imagePickerDelegate
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = imagePickerDelegate
        
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        viewController.present(imagePicker, animated: true, completion: nil)
        
        return imagePickerDelegate.imageSubject.eraseToAnyPublisher()
    }
}

class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private(set) var imageSubject = PassthroughSubject<CapturedImage?, Never>()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage, let imageData = image.pngData() {
            let capturedImage = CapturedImage(imageData: imageData)
            imageSubject.send(capturedImage)
        } else {
            imageSubject.send(nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageSubject.send(nil)
        picker.dismiss(animated: true, completion: nil)
    }
}

//import UIKit
//
//protocol CameraService {
//    func captureImage(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void)
//}
//
//final class DefaultCameraService: NSObject, CameraService, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    private var completion: ((UIImage?) -> Void)?
//
//    func captureImage(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
//        self.completion = completion
//
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            completion(nil)
//            return
//        }
//
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.sourceType = .camera
//        imagePickerController.delegate = self
//
//        viewController.present(imagePickerController, animated: true, completion: nil)
//    }
//
//    // MARK: - UIImagePickerControllerDelegate
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        let image = info[.originalImage] as? UIImage
//        completion?(image)
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        completion?(nil)
//        picker.dismiss(animated: true, completion: nil)
//    }
//}

