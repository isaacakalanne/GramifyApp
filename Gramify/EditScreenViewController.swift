//
//  EditScreenViewController.swift
//  Gramify
//
//  Created by Isaac Akalanne on 04/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import UIKit

class EditScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var modeSelectCollectionView: UICollectionView!
    @IBOutlet weak var primaryEditCollectionView: UICollectionView!
    @IBOutlet weak var secondaryEditCollectionView: UICollectionView!
    
    let modeSelectCellIdentifier = "modeSelectCell"
    let primaryEditCellIdentifier = "primaryEditCell"
    let secondaryEditCellIdentifier = "secondaryEditCell"
    
    var selectedFilter = "pinkRoses"
    var originalImage = UIImage()
    var filteredImage = UIImage()
    
    let imageConverter = ImageConverter()
    let modesDataStore = ModesDataStore()
    var listOfModes : Array<[String : Any]> = []
    
    let filtersDataStore = FiltersDataStore()
    var listOfFilters : Array<[String : Any]> = []
    var originalFilterImage = UIImage()
    
    let fadesDataStore = FadesDataStore()
    var listOfFades : Array<UIImage> = []
    
    var currentModeIndex = 0
    var currentFilterIndex = 0
    var fadeDirectionIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImages()
        initialiseImagePreview()
        
        initialiseListsOfItems()
        initialiseCollectionView(modeSelectCollectionView)
        initialiseCollectionView(primaryEditCollectionView)
        initialiseCollectionView(secondaryEditCollectionView)
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
    
    func initialiseCollectionView(_ collectionView : UICollectionView) {
        let layout = createLayout(forCollectionView: collectionView)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func createLayout(forCollectionView collectionView : UICollectionView) -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.size.width
        
        let itemCount = getListSize(forCollectionView: collectionView)
        let itemCountAsFloat = CGFloat(itemCount)
        
        layout.itemSize = CGSize(width: screenWidth/itemCountAsFloat, height: collectionView.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        return layout
    }
    
    func initialiseListsOfItems() {
        listOfModes = modesDataStore.getListOfModes()
        listOfFilters = filtersDataStore.getListOfFilters()
        listOfFades = fadesDataStore.getListOfBlackFadeDictionaries()
    }
    
    func getListOfItems(forCollectionView collectionView : UICollectionView) -> Array<Any> {
        if collectionView === modeSelectCollectionView {
            return listOfModes
        } else if collectionView === primaryEditCollectionView {
            return listOfFilters
        } else if collectionView === secondaryEditCollectionView {
            return listOfFades
        } else {
            return []
        }
    }
    
    func getListSize(forCollectionView collectionView : UICollectionView) -> Int {
        let listOfItems = getListOfItems(forCollectionView: collectionView)
        let count = listOfItems.count
        return count
    }
    
    @objc func fadeButtonPressed(sender : UIButton) {
        let fadeDirection = sender.accessibilityIdentifier!
        let filterName = "\(selectedFilter + fadeDirection)"
        var filterImage = UIImage(named: filterName)
        filterImage = imageConverter.resizeImage(filterImage: filterImage!, toSizeOfImage: originalImage)
        imageConverter.applyFilter("CILinearDodgeBlendMode", toImage: self.originalImage, withFilterImage: filterImage!) { filteredImage in
            
            UIView.animate(withDuration: 0.4) {
                self.imagePreview.image = filteredImage // This doesn't currently correctly animate the transition
                self.filteredImage = filteredImage
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == modeSelectCollectionView {
            return modesDataStore.getListOfModes().count
        } else if collectionView == primaryEditCollectionView {
            return filtersDataStore.getListOfFilters().count
        } else if collectionView == secondaryEditCollectionView {
            return fadesDataStore.getListOfBlackFadeDictionaries().count
       } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let reuseIdentifier = getCellReuseIdentifier(forCollectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)
        
        let cellImageView = UIImageView()
        let cellImage = getCellImage(atIndex: indexPath.item, inCollectionView: collectionView)
        cellImageView.frame = getFrameForImageView(inCell: cell)
        cellImageView.contentMode = .scaleAspectFit
        cellImageView.image = cellImage
        
        if collectionView !== modeSelectCollectionView {
            roundCornersOfView(cellImageView)
        }
        
        cell.addSubview(cellImageView)

        return cell
    }
    
    func getCellImage(atIndex index : Int, inCollectionView cv : UICollectionView) -> UIImage {
        
        var image : UIImage
        
        if cv === secondaryEditCollectionView {
            let listOfImages = getListOfItems(forCollectionView: cv)
            image = listOfImages[index] as! UIImage
        } else {
            let imageName = getCellImageName(atIndex: index, inCollectionView: cv)
            image = UIImage(named: imageName)!
        }
        
        return image
    }
    
    func getCellImageName(atIndex index : Int, inCollectionView cv : UICollectionView) -> String {
        var imageName : String
        let listOfItems = getListOfItems(forCollectionView: cv)
        
        if cv === secondaryEditCollectionView {
            imageName = ""
        } else {
            let currentItem = listOfItems[index] as! Dictionary<String, Any>
            imageName = currentItem["defaultImageName"] as! String
        }
        return imageName
    }
    
    func roundCornersOfView(_ view : UIView) {
        view.layer.cornerRadius = view.bounds.size.width / 3
        view.clipsToBounds = true
    }
    
    func getFrameForImageView(inCell cell : UICollectionViewCell) -> CGRect {
        let cellWidth = cell.bounds.size.width
        let cellHeight = cell.bounds.size.height
        let frame = CGRect(x: cellWidth / 2 - cellHeight / 2, y: 0, width: cellHeight, height: cellHeight)
        return frame
    }
    
    func getCellReuseIdentifier(forCollectionView collectionView : UICollectionView) -> String {
        if collectionView === modeSelectCollectionView {
            return modeSelectCellIdentifier
        } else if collectionView === primaryEditCollectionView {
            return primaryEditCellIdentifier
        } else if collectionView === secondaryEditCollectionView {
           return secondaryEditCellIdentifier
       } else {
            return ""
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let listOfItemsCount = getListSize(forCollectionView: collectionView)
        let itemCountAsFloat = CGFloat(listOfItemsCount)
        
        return CGSize(width: screenWidth/itemCountAsFloat, height: collectionView.bounds.size.height)
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView === secondaryEditCollectionView {
            
            fadeDirectionIndex = indexPath.item
            applyFilter(withFilterImageIndex: currentFilterIndex, andFadeDirectionIndex: fadeDirectionIndex)
            
        } else if collectionView === primaryEditCollectionView {
            
            currentFilterIndex = indexPath.item
            
        } else if collectionView === modeSelectCollectionView {
            
            currentModeIndex = indexPath.item
            
        }
        
    }
    
    func applyFilter(withFilterImageIndex filterIndex : Int, andFadeDirectionIndex fadeIndex : Int) {
        
        let filterImage = getFilterImage(atIndex: filterIndex)!
        let blackFadeImage = UIImage(named: "blackFade")!
        
        overlayImage(filterImage, withImage: blackFadeImage, andFadeDirectionIndex: fadeIndex)
        
    }
    
    func getFilterImage(atIndex index : Int) -> UIImage? {
        let filterImageData = listOfFilters[index]
        let filterImageName = filterImageData["defaultImageName"] as! String
        let filterImage = UIImage(named: filterImageName)!
        
        return filterImage
    }
    
    func overlayImage(_ image : UIImage, withImage overlayImage : UIImage, andFadeDirectionIndex fadeIndex : Int) {
        imageConverter.applyFilter("CISourceOverCompositing", toImage: image, withFilterImage: overlayImage) { filterImage in
            
            self.filterUserImage(self.originalImage, withFilterType: "CILinearDodgeBlendMode", andFilterImage: filterImage)
        }
    }
    
    func filterUserImage(_ image : UIImage, withFilterType filterName : String, andFilterImage filterImage : UIImage) {
        
        let scale = getScaleForFilterImageFlipping()
        
        let flippedFilterImage = imageConverter.flipImageWithScale(xScale: scale.x, yScale: scale.y, image: filterImage)!
        
        let resizedImage = imageConverter.resizeImage(filterImage: flippedFilterImage, toSizeOfImage: image)
        
        imageConverter.applyFilter(filterName, toImage: self.originalImage, withFilterImage: resizedImage, completion: { filteredImage in
            
            self.filteredImage = filteredImage
            self.imagePreview.image = self.filteredImage
            
            print("Done!")
            
        })
    }
    
    func getScaleForFilterImageFlipping() -> (x: CGFloat, y: CGFloat) {
        switch fadeDirectionIndex {
        case 0:
            return (x: -1, y: 1)
        case 1:
            return (x: -1, y: -1)
        case 2:
            return (x: 1, y: -1)
        case 3:
            return (x: 1, y: 1)
        default:
            return (x: 1, y: 1)
        }
    }

}
