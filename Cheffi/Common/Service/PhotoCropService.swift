//
//  PhotoCropService.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/13.
//

import UIKit

class PhotoCropService {
    
    func cropImageData(_ imageData: Data, in rect: CGRect) -> Data? {
        guard let imageToCrop = UIImage(data: imageData) else {
            return nil
        }

        guard let croppedCGImage = imageToCrop.cgImage?.cropping(to: rect) else {
            return nil
        }

        let croppedImage = UIImage(cgImage: croppedCGImage)
        return croppedImage.pngData()
    }
    
    func cropImageToCircle(_ image: UIImage, diameter: CGFloat) -> UIImage? {
        let size = CGSize(width: diameter, height: diameter)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let outputImage = renderer.image { context in
            context.cgContext.addEllipse(in: CGRect(origin: .zero, size: size))
            context.cgContext.clip()
            
            image.draw(in: CGRect(origin: CGPoint(x: (diameter - image.size.width) / 2.0,
                                               y: (diameter - image.size.height) / 2.0),
                                  size: image.size))
        }
        
        return outputImage
    }
}
