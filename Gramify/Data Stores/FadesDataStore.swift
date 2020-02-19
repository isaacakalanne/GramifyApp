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
    
    var fadeBottomRight = UIImage(named: "blackFade")
    var fadeBottomLeft = UIImage(named: "blackFade")
    var fadeTopLeft = UIImage(named: "blackFade")
    var fadeTopRight = UIImage(named: "blackFade")
    
    func getListOfFlippedImages() -> Array<UIImage> {
        fadeBottomRight = UIImage(cgImage: (fadeBottomLeft?.cgImage)!, scale: 1.0, orientation: .up)
        fadeTopRight = UIImage(cgImage: (fadeTopRight?.cgImage)!, scale: 1.0, orientation: .left)
        fadeTopLeft = UIImage(cgImage: (fadeTopLeft?.cgImage)!, scale: 1.0, orientation: .down)
        fadeBottomLeft = UIImage(cgImage: (fadeBottomLeft?.cgImage)!, scale: 1.0, orientation: .right)
        let listOfImages : Array<UIImage> = [fadeBottomRight!, fadeTopRight!, fadeTopLeft!, fadeBottomLeft!]
        return listOfImages
    }
    
}
