//
//  FiltersDataStore.swift
//  Gramify
//
//  Created by Isaac Akalanne on 15/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation

struct FilterImages {
    
    struct Filter {
        
        let displayName : String
        let imageFileName : String
        
        init(displayName : String, imageFileName : String) {
            self.displayName = displayName
            self.imageFileName = imageFileName
        }
        
    }
    
    var pinkRoses = Filter(displayName: "Pink Roses", imageFileName: "pinkRoses")
    var oceanWave = Filter(displayName: "Ocean Wave", imageFileName: "oceanWave")
    var fallingLeaves = Filter(displayName: "Falling Leaves", imageFileName: "fallingLeaves")
    var nightSky = Filter(displayName: "Night Sky", imageFileName: "nightSky")
    
    func getListOfFilters() -> Array<Filter> {
        let listOfFilters = [pinkRoses, oceanWave, fallingLeaves, nightSky]
        return listOfFilters
    }
    
}
