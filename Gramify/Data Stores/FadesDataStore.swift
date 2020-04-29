//
//  FadesDataStore.swift
//  Gramify
//
//  Created by Isaac Akalanne on 18/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation
import UIKit

class FadesDataStore {
    
    let imageConverter = ImageConverter()
    
    let blackFadeImage = UIImage(named: "blackFade")!
    
    var blackFadeBottomRight : [String : Any] = [:]
    var blackFadeTopRight : [String : Any] = [:]
    var blackFadeTopLeft : [String : Any] = [:]
    var blackFadeBottomLeft : [String : Any] = [:]
    
    func getListOfBlackFadeDictionaries() -> Array<UIImage> {
        
        let bottomRightImage = UIImage(cgImage: (blackFadeImage.cgImage)!, scale: 1.0, orientation: .up)
        let topRightImage = UIImage(cgImage: (blackFadeImage.cgImage)!, scale: 1.0, orientation: .left)
        let topLeftImage = UIImage(cgImage: (blackFadeImage.cgImage)!, scale: 1.0, orientation: .down)
        let bottomLeftImage = UIImage(cgImage: (blackFadeImage.cgImage)!, scale: 1.0, orientation: .right)
        
        let listOfBlackFades : Array<UIImage> = [bottomRightImage, topRightImage, topLeftImage, bottomLeftImage]
        return listOfBlackFades
    }
    
}
