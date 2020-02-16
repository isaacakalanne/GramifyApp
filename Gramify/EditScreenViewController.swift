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
    @IBOutlet weak var editSelectCollectionView: UICollectionView!
    @IBOutlet weak var modeSelectCollectionView: UICollectionView!
    
    var selectedFilter = "pinkRoses"
    var originalImage = UIImage()
    var filteredImage = UIImage()
    
    let imageConverter = ImageConverter()
    let filtersDataStore = FiltersDataStore()
    let modesDataStore = ModesDataStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImages()
        initialiseImagePreview()
        
        initialiseCollectionView(modeSelectCollectionView)
        initialiseCollectionView(editSelectCollectionView)
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
        let listOfItems = getListOfItems(forCollectionView: collectionView)
        let itemCount = CGFloat(listOfItems.count)
        
        layout.itemSize = CGSize(width: screenWidth/itemCount, height: collectionView.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        return layout
    }
    
    func getListOfItems(forCollectionView collectionView : UICollectionView) -> Array<Any> {
        if collectionView === modeSelectCollectionView {
            return modesDataStore.getListOfModes()
        } else if collectionView === editSelectCollectionView {
            return filtersDataStore.getListOfFilters()
        } else {
            return []
        }
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
        } else if collectionView == editSelectCollectionView {
            return filtersDataStore.getListOfFilters().count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let reuseIdentifier = getReuseIdentifier(forCollectionView: collectionView)
        let listOfItems = getListOfItems(forCollectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)
        
        let currentItem = listOfItems[indexPath.item] as! Dictionary<String, Any>
        let imageName = currentItem["imageFileName"] as! String
        
        let cellImageView = UIImageView()
        cellImageView.image = UIImage(named: imageName)
        cellImageView.frame = createFrameForImageView(inCell: cell)
        cellImageView.contentMode = .scaleAspectFit
        
        if collectionView === editSelectCollectionView {
            cellImageView.layer.cornerRadius = cellImageView.bounds.size.width / 3
            cellImageView.clipsToBounds = true
        }
        
        cell.addSubview(cellImageView)

        return cell
    }
    
    func createFrameForImageView(inCell cell : UICollectionViewCell) -> CGRect {
        let cellWidth = cell.bounds.size.width
        let cellHeight = cell.bounds.size.height
        let frame = CGRect(x: cellWidth / 2 - cellHeight / 2, y: 0, width: cellHeight, height: cellHeight)
        return frame
    }
    
    func getReuseIdentifier(forCollectionView collectionView : UICollectionView) -> String {
        if collectionView === modeSelectCollectionView {
            return "modeSelectCell"
        } else if collectionView === editSelectCollectionView {
            return "editSelectCell"
        } else {
            return ""
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        print("Running!")
        if collectionView == modeSelectCollectionView {
            return CGSize(width: screenWidth/3, height: collectionView.bounds.size.height)
        } else if collectionView == editSelectCollectionView {
            return CGSize(width: screenWidth/4, height: collectionView.bounds.size.height)
        } else {
            return CGSize(width: 0, height: 0)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell index is \(indexPath.item)!")
    }

}
