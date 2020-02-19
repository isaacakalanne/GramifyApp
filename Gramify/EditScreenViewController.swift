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
    
    var selectedFilter = "pinkRoses"
    var originalImage = UIImage()
    var filteredImage = UIImage()
    
    let imageConverter = ImageConverter()
    let modesDataStore = ModesDataStore()
    let filtersDataStore = FiltersDataStore()
    let fadesDataStore = FadesDataStore()
    
    var currentModeIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImages()
        initialiseImagePreview()
        
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
        let listOfItemsCount = getListSize(forCollectionView: collectionView)
        let itemCountAsFloat = CGFloat(listOfItemsCount)
        
        layout.itemSize = CGSize(width: screenWidth/itemCountAsFloat, height: collectionView.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        return layout
    }
    
    func getListOfItems(forCollectionView collectionView : UICollectionView) -> Array<Any> {
        if collectionView === modeSelectCollectionView {
            return modesDataStore.getListOfModes()
        } else if collectionView === primaryEditCollectionView {
            return filtersDataStore.getListOfFilters()
        } else if collectionView === secondaryEditCollectionView {
            return fadesDataStore.getListOfFlippedImages()
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
        imageConverter.applyFilter(toImage: self.originalImage, withFilterImage: filterImage!) { filteredImage in
            
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
            return fadesDataStore.getListOfFlippedImages().count
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
            let listOfItems = getListOfItems(forCollectionView: cv)
            image = listOfItems[index] as! UIImage
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
            return "modeSelectCell"
        } else if collectionView === primaryEditCollectionView {
            return "primaryEditCell"
        } else if collectionView === secondaryEditCollectionView {
           return "secondaryEditCell"
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
        print("Cell index is \(indexPath.item)!")
        currentModeIndex = indexPath.item
    }

}
