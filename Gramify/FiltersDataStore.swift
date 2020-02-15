//
//  FiltersDataStore.swift
//  Gramify
//
//  Created by Isaac Akalanne on 15/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation

class FiltersDataStore {
    
    let pinkRosesFilter = ["filterName" : "Pink Roses",
                           "imageFileName" : "pinkRoses"]
    
    let oceanWaveFilter = ["filterName" : "Ocean Wave",
                           "imageFileName" : "oceanWave"]
    
    let fallingLeavesFilter = ["filterName" : "Falling Leaves",
                               "imageFileName" : "fallingLeaves"]
    
    let nightSkyFilter = ["filterName" : "Night Sky",
                          "imageFileName" : "nightSky"]
    
    func getListOfFilters() -> Array<Dictionary<String, Any>> {
        let listOfFilters = [pinkRosesFilter, oceanWaveFilter, fallingLeavesFilter, nightSkyFilter]
        return listOfFilters
    }
    
}
