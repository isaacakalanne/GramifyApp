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
        let widthRatio = targetImage.size.width / originalImage.size.width
        let heightRatio = targetImage.size.height / originalImage.size.height
        originalImage.draw(in: CGRect(x: 0, y: 0, width: targetImage.size.width / widthRatio, height: targetImage.size.height / heightRatio))
        let resizedFilterImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedFilterImage
    }
    
    // TO DO :
    // - Add feature to have filters 'behind' a person as well - Either app detects the person's outline and can place images 'behind' them, or the user has a feature to easily manually cutout their outline
    //   - Can also put animated filters behind person (falling leaves, floating lights, etc)
    //   - Can animate background itself (make the clouds move, make the waves roll, etc)
    //   - Research AI in apps, and available public AI app resources, for detecting objects in images
    
    func applyFilter(_ filterName : String, toImage image : UIImage , withFilterImage filterImage : UIImage , completion : @escaping ((_ filteredImage : UIImage) -> Void)) {
            let originalImage = CIImage(image: image)
            let filterImage = CIImage(image: filterImage)
            
    //        CIAdditionCompositing
    //        CIColorBlendMode
    //        CIColorBurnBlendMode
    //        CIColorDodgeBlendMode <--
    //        CIDarkenBlendMode
    //        CIDifferenceBlendMode <------
    //        CIDivideBlendMode <--
    //        CIExclusionBlendMode <------
    //        CIHardLightBlendMode
    //        CIHueBlendMode
    //        CILightenBlendMode
    //        CILinearBurnBlendMode
    //        CILinearDodgeBlendMode <------
    //        CILuminosityBlendMode
    //        CIMaximumCompositing
    //        CIMinimumCompositing
    //        CIMultiplyBlendMode
    //        CIMultiplyCompositing
    //        CIOverlayBlendMode
    //        CIPinLightBlendMode
    //        CISaturationBlendMode
    //        CIScreenBlendMode
    //        CISoftLightBlendMode
    //        CISourceAtopCompositing
    //        CISourceInCompositing
    //        CISourceOutCompositing
    //        CISourceOverCompositing
    //        CISubtractBlendMode <------
            
            let filter = CIFilter(name: filterName)
            filter?.setValue(originalImage, forKey: "inputBackgroundImage")
            filter?.setValue(filterImage, forKey: "inputImage")
            
            let imageRef = (filter?.outputImage!.cropped(to: (filter?.outputImage!.extent)!))!
            let imageWithFilter = UIImage(ciImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
            completion(imageWithFilter)
    }
    
    func flipImageWithScale(_ image : UIImage, _ scale : (x: CGFloat, y: CGFloat)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let bitmap = UIGraphicsGetCurrentContext()!
        
        bitmap.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        bitmap.scaleBy(x: scale.x, y: scale.y)
        bitmap.translateBy(x: -image.size.width / 2, y: -image.size.height / 2)
        
        var cgImage : CGImage
        
        if image.ciImage == nil {
            let ciImage = CIImage(image: image)!
            cgImage = convertImageToCGImage(ciImage)
        } else {
            cgImage = convertImageToCGImage(image)!
        }
        
        bitmap.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    func convertImageToCGImage(_ image : UIImage) -> CGImage! {
        let context = CIContext()
        let filteredCGImage = context.createCGImage(image.ciImage!, from: image.ciImage!.extent)
        return filteredCGImage
    }
    
    func convertImageToCGImage(_ image : CIImage) -> CGImage! {
        let context = CIContext()
        let filteredCGImage = context.createCGImage(image, from: image.extent)
        return filteredCGImage
    }
    
}
