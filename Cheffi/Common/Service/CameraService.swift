//
//  CameraService.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/12.
//

import UIKit

protocol CameraService {
    func captureImage(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void)
}

final class DefaultCameraService: NSObject, CameraService, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var completion: ((UIImage?) -> Void)?
    
    deinit {
#if DEBUG
        print("DefaultCameraService deinit")
#endif
    }

    func captureImage(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        self.completion = completion

        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            completion(nil)
            return
        }

        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self

        viewController.present(imagePickerController, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        completion?(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        completion?(nil)
    }
}

