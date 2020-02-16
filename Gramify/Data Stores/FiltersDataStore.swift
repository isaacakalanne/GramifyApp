//
//  FiltersDataStore.swift
//  Gramify
//
//  Created by Isaac Akalanne on 15/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation

class FiltersDataStore {
    
    let pinkRoses = ["filterName" : "Pink Roses",
                           "imageFileName" : "pinkRoses"]
    
    let oceanWave = ["filterName" : "Ocean Wave",
                           "imageFileName" : "oceanWave"]
    
    let fallingLeaves = ["filterName" : "Falling Leaves",
                               "imageFileName" : "fallingLeaves"]
    
    let nightSky = ["filterName" : "Night Sky",
                          "imageFileName" : "nightSky"]
    
    func getListOfFilters() -> Array<Dictionary<String, Any>> {
        let listOfFilters = [pinkRoses, oceanWave, fallingLeaves, nightSky]
        return listOfFilters
    }
    
}
