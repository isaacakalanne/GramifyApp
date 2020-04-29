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
    
    func getListOfBlackFadeDictionaries() -> Array<[String : Any]> {
        
        let bottomRightImage = UIImage(cgImage: (blackFadeImage.cgImage)!, scale: 1.0, orientation: .up)
        blackFadeBottomRight = ["image" : bottomRightImage,
                                "xString" : Origin.bottomRight().x,
                                "yString" : Origin.bottomRight().y] as [String : Any]
        
        let topRightImage = UIImage(cgImage: (blackFadeImage.cgImage)!, scale: 1.0, orientation: .left)
        blackFadeTopRight = ["image" : topRightImage,
                            "xString" : Origin.topRight().x,
                            "yString" : Origin.topRight().y] as [String : Any]
        
        let topLeftImage = UIImage(cgImage: (blackFadeImage.cgImage)!, scale: 1.0, orientation: .down)
        blackFadeTopLeft = ["image" : topLeftImage,
                            "xString" : Origin.topLeft().x,
                            "yString" : Origin.topLeft().y] as [String : Any]
        
        let bottomLeftImage = UIImage(cgImage: (blackFadeImage.cgImage)!, scale: 1.0, orientation: .right)
        blackFadeBottomLeft = ["image" : bottomLeftImage,
                               "xString" : Origin.bottomLeft().x,
                               "yString" : Origin.bottomLeft().y] as [String : Any]
        
        let listOfBlackFades : Array<[String : Any]> = [blackFadeBottomRight, blackFadeTopRight, blackFadeTopLeft, blackFadeBottomLeft]
        return listOfBlackFades
    }
    
    func getFadeForOrigin(x : String, y : String) -> UIImage {
        var rotatedBlackFadeImage = UIImage()
        
        if y == "bottom", x == "right" {
            rotatedBlackFadeImage = blackFadeImage
        } else if y == "top", x == "right" {
            rotatedBlackFadeImage = imageConverter.rotateImage(blackFadeImage, byDegrees: 270)
        } else if y == "top", x == "left" {
            rotatedBlackFadeImage = imageConverter.rotateImage(blackFadeImage, byDegrees: 180)
        } else if y == "bottom", x == "left" {
            rotatedBlackFadeImage = imageConverter.rotateImage(blackFadeImage, byDegrees: 90)
        }
        return rotatedBlackFadeImage
    }
    
}
