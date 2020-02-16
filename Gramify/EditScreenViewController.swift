//
//  EditScreenViewController.swift
//  Gramify
//
//  Created by Isaac Akalanne on 04/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import UIKit

class EditScreenViewController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var editSelectCollectionView: UICollectionView!
    @IBOutlet weak var modeSelectCollectionView: UICollectionView!
    
    var selectedFilter = "pinkRoses"
    var originalImage = UIImage()
    var filteredImage = UIImage()
    var listOfFilters : Array<Any> = []
    var listOfModes : Array<Any> = []
    
    let filtersDataStore = FiltersDataStore()
    let modesDataStore = ModesDataStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImages()
        initialiseImagePreview()
        createArraysForTableViews()
    }
    
    func createImages() {
        originalImage = UIImage(named: "testPortrait2")!
        filteredImage = originalImage
    }
    
    func initialiseImagePreview() {
        imagePreview.alpha = 0
        imagePreview.image = originalImage
        
        UIView.animate(withDuration: 0.4) {
            self.imagePreview.alpha = 1
        }
    }
    
    func createArraysForTableViews() {
        listOfFilters = filtersDataStore.getListOfFilters()
        listOfModes = modesDataStore.getListOfModes()
    }
    
    @objc func fadeButtonpressed(sender : UIButton) {
        let fadeDirection = sender.accessibilityIdentifier!
        let filterName = "\(selectedFilter + fadeDirection)"
        var filterImage = UIImage(named: filterName)
        filterImage = convertImage(filterImage: filterImage!, toSizeOfImage: originalImage)
        self.applyFilter(toImage: self.originalImage, withFilterImage: filterImage!) { filteredImage in
            
            UIView.animate(withDuration: 0.4) {
                self.imagePreview.image = filteredImage // This doesn't currently correctly animate the transition
                self.filteredImage = filteredImage
            }
        }
    }
    
    func flipImageLeftRight(_ image: UIImage) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: image.size.width, y: image.size.height)
        context.scaleBy(x: -image.scale, y: -image.scale)
        context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return newImage
    }
    
    func convertImage(filterImage : UIImage , toSizeOfImage userImage : UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(userImage.size, false, 0.0);
        filterImage.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: userImage.size.width, height: userImage.size.height)))
        let resizedFilterImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedFilterImage
    }
    
    func setFadeBackground(forButton button : UIButton , withFilter filterName : String) {
        let imageName = "\(filterName + button.accessibilityIdentifier!)"
        button.setBackgroundImage(UIImage(named: imageName), for: .normal)
    }
    
    // TO DO :
    // - Use CISourceAtopCompositing (or similar CIFilter) to combine user-uploaded filter image and image of black-to-transparent fade. This combined image can then be used as a faded filter image, rather than having to individually create each one. These images can then be flipped horizontally and vertically to fade from all 4 corners.
    // - Change'Ddownload' button to 'Upload' button, to allow user to upload their image to Instagram (or other online platform) with one click
    
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
