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
                           "defaultImageName" : "pinkRoses",
                           "blackFadePosition" : Origin.topRight()] as [String : Any]
    
    let oceanWave = ["filterName" : "Ocean Wave",
                           "defaultImageName" : "oceanWave",
                           "blackFadePosition" : Origin.bottomLeft()] as [String : Any]
    
    let fallingLeaves = ["filterName" : "Falling Leaves",
                               "defaultImageName" : "fallingLeaves",
                               "blackFadePosition" : Origin.bottomRight()] as [String : Any]
    
    let nightSky = ["filterName" : "Night Sky",
                          "defaultImageName" : "nightSky",
                          "blackFadePosition" : Origin.topLeft()] as [String : Any]
    
    func getListOfFilters() -> Array<[String : Any]> {
        let listOfFilters = [pinkRoses, oceanWave, fallingLeaves, nightSky]
        return listOfFilters
    }
    
}
