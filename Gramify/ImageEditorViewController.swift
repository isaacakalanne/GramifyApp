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
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var pinkRosesFilterButton: UIButton!
    @IBOutlet weak var oceanWaveFilterButton: UIButton!
    @IBOutlet weak var fallingLeavesFilterButton: UIButton!
    @IBOutlet weak var nightSkyFilterButton: UIButton!
    
    @IBOutlet weak var bottomLeftFadeButton: UIButton!
    @IBOutlet weak var topLeftFadeButton: UIButton!
    @IBOutlet weak var topRightFadeButton: UIButton!
    @IBOutlet weak var bottomRightFadeButton: UIButton!
    
    lazy var image = ImgurImage(imageDictionary: [String : Any]())
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
        getData(fromURL: image.link!) { data in
            
            DispatchQueue.main.async {
                
                self.originalImage = UIImage(data: data!)!
                self.imageToUpload = self.originalImage
                
                self.imagePreview.alpha = 0
                self.imagePreview.image = self.originalImage
                
                UIView.animate(withDuration: 0.4) {
                    self.imagePreview.alpha = 1
                }
                
            }
            
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
        
        shareButton.addTarget(self, action: #selector(shareImageToImgur), for: .touchUpInside)
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
        let filterImage = UIImage(named: filterName)
        self.applyFilter(toImage: self.originalImage, withFilterImage: filterImage!) { filteredImage in
            
            UIView.animate(withDuration: 0.4) {
                self.imagePreview.image = filteredImage // This doesn't currently correctly animate the transition
                self.imageToUpload = filteredImage
            }
            
        }
    }
    
    func setFadeBackground(forButton button : UIButton , withFilter filterName : String) {
        let imageName = "\(filterName + button.accessibilityIdentifier!)"
        button.setBackgroundImage(UIImage(named: imageName), for: .normal)
    }
    
    func getData(fromURL urlString:String, completion: @escaping ((_ data: Data?) -> Void)) {
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data)
        }.resume()
        
    }
    
    func applyFilter(toImage image : UIImage , withFilterImage filterImage : UIImage , completion : @escaping ((_ filteredImage : UIImage) -> Void)) {
        let originalImage = CIImage(image: image)
        let filterImage = CIImage(image: filterImage)
        let filter = CIFilter(name: "CIScreenBlendMode")
        filter?.setValue(originalImage, forKey: "inputBackgroundImage")
        filter?.setValue(filterImage, forKey: "inputImage")
        
        let imageRef = (filter?.outputImage!.cropped(to: (filter?.outputImage!.extent)!))!
        let imageWithFilter = UIImage(ciImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        completion(imageWithFilter)
    }
    
    @objc func shareImageToImgur() {
        shareButton.setTitle("Uploading...", for: .normal)
        shareButton.isUserInteractionEnabled = false
        let networkProcessor = NetworkProcessor()
        let url = URL(string: "https://api.imgur.com/3/image")
        networkProcessor.uploadImage(imageToUpload, withURL: url!) { uploadedImageData in
            if let jsonData = uploadedImageData?["data"] as? [String : Any] {
                
                let linkString : String = jsonData["link"] as! String
                guard let url = URL(string: linkString) else { return }
                
                DispatchQueue.main.async {
                    self.shareButton.isUserInteractionEnabled = true
                    self.shareButton.setTitle("Share to Imgur", for: .normal)
                    UIApplication.shared.open(url)
                }
                
            }
        }
    }

}
