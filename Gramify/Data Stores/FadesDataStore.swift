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
    
    func getListOfBlackFadeDictionaries() -> Array<[String : Any]> {
        let blackFadeImage = UIImage(named: "blackFade")
        
        let bottomRightImage = UIImage(cgImage: (blackFadeImage?.cgImage)!, scale: 1.0, orientation: .up)
        let blackFadeBottomRight = ["image" : bottomRightImage,
                                    "origin" : Origin.bottomRight()] as [String : Any]
        
        let topRightImage = UIImage(cgImage: (blackFadeImage?.cgImage)!, scale: 1.0, orientation: .left)
        let blackFadeTopRight = ["image" : topRightImage,
                                 "origin" : Origin.topRight()] as [String : Any]
        
        let topLeftImage = UIImage(cgImage: (blackFadeImage?.cgImage)!, scale: 1.0, orientation: .down)
        let blackFadeTopLeft = ["image" : topLeftImage,
                                 "origin" : Origin.topLeft()] as [String : Any]
        
        let bottomLeftImage = UIImage(cgImage: (blackFadeImage?.cgImage)!, scale: 1.0, orientation: .right)
        let blackFadeBottomLeft = ["image" : bottomLeftImage,
                                 "origin" : Origin.topLeft()] as [String : Any]
        
        let listOfBlackFades : Array<[String : Any]> = [blackFadeBottomRight, blackFadeTopRight, blackFadeTopLeft, blackFadeBottomLeft]
        return listOfBlackFades
    }
    
}
