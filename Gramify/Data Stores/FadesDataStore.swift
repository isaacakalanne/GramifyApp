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
    
    let fadeBottomRight = UIImage(named: "blackFade")
    
    let fadeBottomLeft = UIImage(named: "blackFade")
    
    let fadeTopLeft = UIImage(named: "blackFade")
    
    let fadeTopRight = UIImage(named: "blackFade")
    
    func getAllFadeImages() -> [UIImage] {
        let listOfImages : Array<UIImage> = [fadeBottomRight!, fadeBottomLeft!, fadeTopLeft!, fadeTopRight!]
        return listOfImages
    }
    
}
