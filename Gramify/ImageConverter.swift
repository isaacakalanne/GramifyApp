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
    
    func resizeImage(filterImage : UIImage , toSizeOfImage userImage : UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(userImage.size, false, 0.0);
        filterImage.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: userImage.size.width, height: userImage.size.height)))
        let resizedFilterImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedFilterImage
    }
    
    // TO DO :
    // - Use CISourceAtopCompositing (or similar CIFilter) to combine user-uploaded filter image and image of black-to-transparent fade. This combined image can then be used as a faded filter image, rather than having to individually create each one. These images can then be flipped horizontally and vertically to fade from all 4 corners
    // - Change'Download' button to 'Upload' button, to allow user to upload their image to Instagram (or other online platform) with one click
    // - Add feature to have filters 'behind' a person as well - Either app detects the person's outline and can place images 'behind' them, or the user has a feature to easily manually cutout their outline
    //   - Can also put animated filters behind person (falling leaves, floating lights, etc)
    //   - Can animate background itself (make the clouds move, make the waves roll, etc)
    //   - Research AI in apps, and available public AI app resources, for detecting objects in images
    
    func applyFilter(toImage image : UIImage , withFilterImage filterImage : UIImage , completion : @escaping ((_ filteredImage : UIImage) -> Void)) {
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
            
            let filter = CIFilter(name: "CILinearDodgeBlendMode")
            filter?.setValue(originalImage, forKey: "inputBackgroundImage")
            filter?.setValue(filterImage, forKey: "inputImage")
            
            let imageRef = (filter?.outputImage!.cropped(to: (filter?.outputImage!.extent)!))!
            let imageWithFilter = UIImage(ciImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
            completion(imageWithFilter)
        }
    
}
