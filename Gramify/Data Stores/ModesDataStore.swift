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
                      "imageFileName" : "flowerW"]
    
    let maskMode = ["modeName" : "Mask",
                    "imageFileName" : "circlesW"]
    
    let downloadMode = ["modeName" : "Upload",
    "imageFileName" : "uploadW"]
    
    func getListOfModes() -> Array<Dictionary<String, Any>> {
        let listOfModes = [filterMode, maskMode, downloadMode]
        return listOfModes
    }
    
}
