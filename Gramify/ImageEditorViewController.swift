//
//  ImageEditorViewController.swift
//  Gramify
//
//  Created by Isaac Akalanne on 04/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import UIKit

class ImageEditorViewController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var filtersScrollView: UIScrollView!
    @IBOutlet weak var fadeTypeScrollView: UIScrollView!
    
    @IBOutlet weak var pinkRosesFilterButton: UIButton!
    @IBOutlet weak var oceanWaveFilterButton: UIButton!
    @IBOutlet weak var fallingLeavesFilterButton: UIButton!
    @IBOutlet weak var nightSkyFilterButton: UIButton!
    
    @IBOutlet weak var bottomLeftFadeButton: UIButton!
    @IBOutlet weak var topLeftFadeButton: UIButton!
    @IBOutlet weak var topRightFadeButton: UIButton!
    @IBOutlet weak var bottomRightFadeButton: UIButton!
    
    var selectedFilter = "pinkRoses"
    var originalImage = UIImage()
    var imageToUpload = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIdentifiersForButtons()
        addTargetsToButtons()
        addImageToImagePreview()
        
    }
    
    func addImageToImagePreview() {
        
        originalImage = UIImage(named: "testPortrait2")!
        
        imageToUpload = originalImage
        
        imagePreview.alpha = 0
        imagePreview.image = originalImage
        
        UIView.animate(withDuration: 0.4) {
            self.imagePreview.alpha = 1
        }
        
    }
    
    func setIdentifiersForButtons() {
        pinkRosesFilterButton.accessibilityIdentifier = "pinkRoses"
        oceanWaveFilterButton.accessibilityIdentifier = "oceanWave"
        fallingLeavesFilterButton.accessibilityIdentifier = "fallingLeaves"
        nightSkyFilterButton.accessibilityIdentifier = "nightSky"
        
        bottomLeftFadeButton.accessibilityIdentifier = "BottomLeft"
        topLeftFadeButton.accessibilityIdentifier = "TopLeft"
        topRightFadeButton.accessibilityIdentifier = "TopRight"
        bottomRightFadeButton.accessibilityIdentifier = "BottomRight"
    }
    
    func addTargetsToButtons() {
        pinkRosesFilterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        oceanWaveFilterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        fallingLeavesFilterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        nightSkyFilterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        
        bottomLeftFadeButton.addTarget(self, action: #selector(fadeButtonpressed), for: .touchUpInside)
        topLeftFadeButton.addTarget(self, action: #selector(fadeButtonpressed), for: .touchUpInside)
        topRightFadeButton.addTarget(self, action: #selector(fadeButtonpressed), for: .touchUpInside)
        bottomRightFadeButton.addTarget(self, action: #selector(fadeButtonpressed), for: .touchUpInside)
    }
    
    @objc func filterButtonPressed(sender : UIButton) {
        if selectedFilter != sender.accessibilityIdentifier {
            selectedFilter = sender.accessibilityIdentifier!
            setFadeBackground(forButton: bottomLeftFadeButton, withFilter: selectedFilter)
            setFadeBackground(forButton: topLeftFadeButton, withFilter: selectedFilter)
            setFadeBackground(forButton: topRightFadeButton, withFilter: selectedFilter)
            setFadeBackground(forButton: bottomRightFadeButton, withFilter: selectedFilter)
            print("Changing fade images!")
        }
    }
    
    @objc func fadeButtonpressed(sender : UIButton) {
        let fadeDirection = sender.accessibilityIdentifier!
        let filterName = "\(selectedFilter + fadeDirection)"
        var filterImage = UIImage(named: filterName)
        filterImage = convertImage(filterImage: filterImage!, toSizeOfImage: originalImage)
        self.applyFilter(toImage: self.originalImage, withFilterImage: filterImage!) { filteredImage in
            
            UIView.animate(withDuration: 0.4) {
                self.imagePreview.image = filteredImage // This doesn't currently correctly animate the transition
                self.imageToUpload = filteredImage
            }
            
        }
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
