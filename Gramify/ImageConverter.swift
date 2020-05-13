//
//  ImageConverter.swift
//  Gramify
//
//  Created by Isaac Akalanne on 16/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation
import UIKit

class ImageConverter {
    
    func resizeImage(_ originalImage : UIImage , toSizeOfImage targetImage : UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetImage.size, false, 0.0);
        originalImage.draw(in: CGRect(x: 0, y: 0, width: targetImage.size.width, height: targetImage.size.height))
        let resizedFilterImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedFilterImage
    }
    
    func applyFilter(_ filterName : String, toImage image : UIImage , withFilterImage filterImage : UIImage , completion : @escaping ((_ filteredImage : UIImage) -> Void)) {
            let originalImage = CIImage(image: image)
            let filterImage = CIImage(image: filterImage)
            
            let filter = CIFilter(name: filterName)
            filter?.setValue(originalImage, forKey: "inputBackgroundImage")
            filter?.setValue(filterImage, forKey: "inputImage")
            
            let imageRef = (filter?.outputImage!.cropped(to: (filter?.outputImage!.extent)!))!
            let imageWithFilter = UIImage(ciImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
            completion(imageWithFilter)
    }
    
    func flipImageWithScale(_ image : UIImage, _ scale : (x: CGFloat, y: CGFloat)) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        
        guard let bitmap = UIGraphicsGetCurrentContext() else {
            print("Could not create bitmap from current context.")
            return UIImage()
        }
        bitmap.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        bitmap.scaleBy(x: scale.x, y: scale.y)
        bitmap.translateBy(x: -image.size.width / 2, y: -image.size.height / 2)
        
        var cgImage : CGImage
        
        if image.ciImage == nil {
            let ciImage = convertImageToCIImage(image)
            cgImage = convertImageToCGImage(ciImage)
        } else {
            cgImage = convertImageToCGImage(image)
        }
        
        bitmap.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func convertImageToCIImage(_ image : UIImage) -> CIImage {
        guard let ciImage = CIImage(image: image) else {
            print("Could not create CIImage from UIImage")
            return CIImage()
        }
        return ciImage
    }
    
    func convertImageToCGImage(_ image : CIImage) -> CGImage! {
        let context = CIContext()
        let filteredCGImage = context.createCGImage(image, from: image.extent)
        return filteredCGImage
    }
    
    func convertImageToCGImage(_ image : UIImage) -> CGImage! {
        let filteredImage = convertImageToCGImage(image.ciImage!)
        return filteredImage
    }
    
}
