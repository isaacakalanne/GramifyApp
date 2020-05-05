//
//  ModesDataStore.swift
//  Gramify
//
//  Created by Isaac Akalanne on 15/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation

struct ModeButtons {
    
    struct Mode {
        let modeName : String
        let unselectedImageFileName : String
        let selectedImageFileName : String
        init(modeName : String, unselectedImageFileName : String, selectedImageFileName : String) {
            self.modeName = modeName
            self.unselectedImageFileName = unselectedImageFileName
            self.selectedImageFileName = selectedImageFileName
        }
    }
    
    let filter = Mode(modeName: "Filter", unselectedImageFileName: "flowerW", selectedImageFileName: "flowerB")
    let erase = Mode(modeName: "Erase", unselectedImageFileName: "circlesW", selectedImageFileName: "circlesB")
    let post = Mode(modeName: "Post", unselectedImageFileName: "uploadW", selectedImageFileName: "uploadB")
    
    func getListOfModes() -> Array<Mode> {
        let listOfModes = [filter, erase, post]
        return listOfModes
    }
    
}
