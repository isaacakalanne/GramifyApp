//
//  EditScreenViewController.swift
//  Gramify
//
//  Created by Isaac Akalanne on 04/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import UIKit

class EditScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var editSelectCollectionView: UICollectionView!
    @IBOutlet weak var modeSelectCollectionView: UICollectionView!
    
    var selectedFilter = "pinkRoses"
    var originalImage = UIImage()
    var filteredImage = UIImage()
    var listOfFilters : Array<Any> = []
    var listOfModes : Array<Any> = []
    
    let imageConverter = ImageConverter()
    let filtersDataStore = FiltersDataStore()
    let modesDataStore = ModesDataStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImages()
        initialiseImagePreview()
        
        initialiseModeSelectCollectionView()
        initialiseEditSelectCollectionView()
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
    
    func initialiseModeSelectCollectionView() {
        listOfModes = modesDataStore.getListOfModes()
        modeSelectCollectionView.reloadData()
    }
    
    func initialiseEditSelectCollectionView() {
        listOfFilters = filtersDataStore.getListOfFilters()
        editSelectCollectionView.reloadData()
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
            print("count is \(listOfModes.count)")
            return listOfModes.count
        } else if collectionView == editSelectCollectionView {
            print("count is \(listOfFilters.count)")
            return listOfFilters.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var reuseIdentifier : String
        if collectionView == modeSelectCollectionView {
            reuseIdentifier = "modeSelectCell"
        } else if collectionView == editSelectCollectionView {
            reuseIdentifier = "editSelectCell"
        } else {
            reuseIdentifier = ""
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)

        cell.backgroundColor = UIColor.cyan

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell index is \(indexPath.item)!")
    }

}
