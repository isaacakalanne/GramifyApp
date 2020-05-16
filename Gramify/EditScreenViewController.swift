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
    
    var unfilteredImage = UIImage()
    var filteredImage = UIImage()
    
    let filterImages = FilterImages()
    let imageConverter = ImageConverter()
    let modeButtons = ModeButtons()
    var listOfModes : Array<ModeButtons.Mode> = []
    
    var listOfFilters : Array<FilterImages.Filter> = []
    var originalFilterImage = UIImage()
    var filterStyle = "CILinearDodgeBlendMode"
    
    var modeTypeIndex = 0
    var filterTypeIndex = 0
    var fadeTypeIndex = 0
    
    var startPoint = CGPoint()
    var endPoint = CGPoint()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseImages()
        initialiseImagePreview()
        
        initialiseListsOfItems()
        initialiseCollectionView(modeSelectCollectionView)
        initialiseCollectionView(primaryEditCollectionView)
        initialiseCollectionView(secondaryEditCollectionView)
    }
    
    func initialiseImages() {
        unfilteredImage = UIImage(named: "testPortrait2")!
        filteredImage = unfilteredImage
    }
    
    func initialiseImagePreview() {
        imagePreview.alpha = 0
        imagePreview.image = unfilteredImage
        imagePreview.contentMode = .scaleAspectFit
        self.imagePreview.alpha = 1
    }
    
    func initialiseListsOfItems() {
        listOfModes = modeButtons.getListOfModes()
        listOfFilters = filterImages.getListOfFilters()
    }
    
    func initialiseCollectionView(_ collectionView : UICollectionView) {
        let layout = createLayout(forCollectionView: collectionView)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func createLayout(forCollectionView collectionView : UICollectionView) -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let itemCount = getListSize(forCollectionView: collectionView)
        let itemWidth = getCollectionViewItemWidth(forItemCount: itemCount)
        let itemHeight = collectionView.bounds.size.height
        
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        return layout
    }
    
    func getListOfItems(forCollectionView collectionView : UICollectionView) -> Array<Any> {
        if collectionView === modeSelectCollectionView {
            return listOfModes
        } else if collectionView === primaryEditCollectionView {
            return listOfFilters
        } else if collectionView === secondaryEditCollectionView {
            return ["bottomRight", "topRight", "topLeft", "bottomLeft"]
        } else {
            print("Could not return a list of items.")
            return []
        }
    }
    
    func getListSize(forCollectionView collectionView : UICollectionView) -> Int {
        let listOfItems = getListOfItems(forCollectionView: collectionView)
        let count = listOfItems.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == modeSelectCollectionView {
            return modeButtons.getListOfModes().count
        } else if collectionView == primaryEditCollectionView {
            return filterImages.getListOfFilters().count
        } else if collectionView == secondaryEditCollectionView {
            return 4
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
        
        var cellImage : UIImage
        
        if cv === secondaryEditCollectionView {
            let scale = getImageFlippingScale(forIndex: index)
            cellImage = UIImage(named: "blackFade")!
            guard let flippedImage = imageConverter.flipImageWithScale(cellImage, scale) else {
                print("Flip black fade image failed.")
                return UIImage()
            }
            cellImage = flippedImage
        } else if cv === primaryEditCollectionView {
            let fileName = getFilterImageFileName(atIndex: index)
            cellImage = safeCreateUIImage(named: fileName)
        } else if cv === modeSelectCollectionView {
            let fileName = getModeImageFileName(atIndex: index)
            cellImage = safeCreateUIImage(named: fileName)
        } else {
            print("cellImage fell through to here.")
            cellImage = UIImage()
        }
        
        return cellImage
    }
    
    func safeCreateUIImage(named name : String) -> UIImage {
        guard let image = UIImage(named: name) else {
            print("Could not create cellImage from name \(name).")
            return UIImage()
        }
        return image
    }
    
    func getFilterImageFileName(atIndex index : Int) -> String {
        
        let listOfItems = filterImages.getListOfFilters()
        let filter = listOfItems[index]
        let fileName = filter.imageFileName
        
        return fileName
    }
    
    func getModeImageFileName(atIndex index : Int) -> String {
        
        let listOfItems = modeButtons.getListOfModes()
        let modeButton = listOfItems[index]
        let fileName = modeButton.unselectedImageFileName
        
        return fileName
    }
    
    func roundCornersOfView(_ view : UIView) {
        view.layer.cornerRadius = view.bounds.size.width / 3
        view.clipsToBounds = true
    }
    
    func getFrameForImageView(inCell cell : UICollectionViewCell) -> CGRect {
        let cellWidth = cell.bounds.size.width
        let imageSize = cell.bounds.size.height
        let frame = CGRect(x: cellWidth/2 - imageSize/2, y: 0, width: imageSize, height: imageSize)
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
        
        let itemCount = getListSize(forCollectionView: collectionView)
        let itemWidth = getCollectionViewItemWidth(forItemCount: itemCount)
        let itemHeight = collectionView.bounds.size.height
        
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
    
    func getCollectionViewItemWidth(forItemCount : Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        return screenWidth/CGFloat(forItemCount)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView === secondaryEditCollectionView {
            fadeTypeIndex = indexPath.item
            applyFilter()
        } else if collectionView === primaryEditCollectionView {
            filterTypeIndex = indexPath.item
            applyFilter()
        } else if collectionView === modeSelectCollectionView {
            modeTypeIndex = indexPath.item
            if modeTypeIndex != 0 {
                primaryEditCollectionView.alpha = 0
                secondaryEditCollectionView.alpha = 0
            } else {
                primaryEditCollectionView.alpha = 1
                secondaryEditCollectionView.alpha = 1
            }
        }
        
    }
    
    func applyFilter() {
        
        let image = getFilterImage()
        let blackFadeImage = UIImage(named: "blackFade") ?? UIImage()
        
        imageConverter.applyFilter("CISourceOverCompositing", toImage: image, withFilterImage: blackFadeImage) { overlayImage in
            
            self.filterImage(self.unfilteredImage, withOverlayImage: overlayImage)
            
        }
        
    }
    
    func getFilterImage() -> UIImage {
        
        let filter = listOfFilters[filterTypeIndex] as FilterImages.Filter
        let fileName = filter.imageFileName
        
        guard let filterImage = UIImage(named: fileName) else {
            print("Could not get UIImage from file name \(fileName)")
            return UIImage()
        }
        
        return filterImage
    }
    
    func filterImage(_ image : UIImage, withOverlayImage overlayImage : UIImage) {
        
        let scale = getImageFlippingScale(forIndex: fadeTypeIndex)
        var overlayImage = imageConverter.flipImageWithScale(overlayImage, scale)!
        overlayImage = imageConverter.resizeImage(overlayImage, toSizeOfImage: image)
        
        imageConverter.applyFilter(filterStyle, toImage: self.unfilteredImage, withFilterImage: overlayImage, completion: { filteredImage in
            
            self.filteredImage = filteredImage
            self.imagePreview.image = self.filteredImage
            
        })
        
    }
    
    func getImageFlippingScale(forIndex index : Int) -> (x: CGFloat, y: CGFloat) {
        
        switch index {
        case 0:
            return (x: -1, y: 1)
        case 1:
            return (x: -1, y: -1)
        case 2:
            return (x: 1, y: -1)
        case 3:
            return (x: 1, y: 1)
        default:
            NSLog("Default image flipping scale")
            return (x: 0, y: 0)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            startPoint.set(withTouch: touch, inView: imagePreview)
            endPoint = startPoint
            drawLine(fromPoint: startPoint, toPoint: endPoint, color: .clear, width: 50)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            endPoint.set(withTouch: touch, inView: imagePreview)
            drawLine(fromPoint: startPoint, toPoint: endPoint, color: .clear, width: 50)
            startPoint.set(withTouch: touch, inView: imagePreview)
        }
        
    }
    
    func drawLine(fromPoint start: CGPoint, toPoint end:CGPoint, color: UIColor, width: CGFloat) {
        
        let imageRect = getAspectFitCGRect(ofImage: imagePreview.image!, inView: imagePreview)
        UIGraphicsBeginImageContextWithOptions(imagePreview.frame.size, false, 0.0)
        
        imagePreview.image?.draw(in: imageRect)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.setLineWidth(width)
            context.setStrokeColor(color.cgColor)
            context.setLineCap(CGLineCap.round)
            
            context.move(to: start)
            context.addLine(to: end)
            
            context.setBlendMode(CGBlendMode.clear)
            
            context.strokePath()
            
            imagePreview.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
        }
        
    }
    
}
