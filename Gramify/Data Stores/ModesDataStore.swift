//
//  ModesDataStore.swift
//  Gramify
//
//  Created by Isaac Akalanne on 15/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation

class ModesDataStore {
    
    let filterMode = ["modeName" : "Filter",
                      "defaultImageName" : "flowerW",
                      "selectedImageName" : "flowerB"]
    
    let maskMode = ["modeName" : "Mask",
                    "defaultImageName" : "circlesW",
                    "selectedImageName" : "circlesB"]
    
    let downloadMode = ["modeName" : "Upload",
                        "defaultImageName" : "uploadW",
                        "selectedImageName" : "uploadB"]
    
    func getListOfModes() -> Array<[String : Any]> {
        let listOfModes = [filterMode, maskMode, downloadMode]
        return listOfModes
    }
    
}
