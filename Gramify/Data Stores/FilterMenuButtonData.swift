//
//  FiltersDataStore.swift
//  Gramify
//
//  Created by Isaac Akalanne on 15/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation

class FilterMenuButtonData {
    
    let pinkRoses = ["filterName" : "Pink Roses",
                           "defaultImageName" : "pinkRoses"] as [String : Any]
    
    let oceanWave = ["filterName" : "Ocean Wave",
                           "defaultImageName" : "oceanWave"] as [String : Any]
    
    let fallingLeaves = ["filterName" : "Falling Leaves",
                               "defaultImageName" : "fallingLeaves"] as [String : Any]
    
    let nightSky = ["filterName" : "Night Sky",
                          "defaultImageName" : "nightSky"] as [String : Any]
    
    func getListOfFilters() -> Array<[String : Any]> {
        let listOfFilters = [pinkRoses, oceanWave, fallingLeaves, nightSky]
        return listOfFilters
    }
    
}
