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
                           "blackFadeXPosition" : Origin.topRight().x,
                           "blackFadeYPosition" : Origin.topRight().y] as [String : Any]
    
    let oceanWave = ["filterName" : "Ocean Wave",
                           "defaultImageName" : "oceanWave",
                           "blackFadeXPosition" : Origin.bottomLeft().x,
                           "blackFadeYPosition" : Origin.bottomLeft().y] as [String : Any]
    
    let fallingLeaves = ["filterName" : "Falling Leaves",
                               "defaultImageName" : "fallingLeaves",
                               "blackFadeXPosition" : Origin.bottomRight().x,
                               "blackFadeYPosition" : Origin.bottomRight().y] as [String : Any]
    
    let nightSky = ["filterName" : "Night Sky",
                          "defaultImageName" : "nightSky",
                          "blackFadeXPosition" : Origin.topLeft().x,
                          "blackFadeYPosition" : Origin.topLeft().y] as [String : Any]
    
    func getListOfFilters() -> Array<[String : Any]> {
        let listOfFilters = [pinkRoses, oceanWave, fallingLeaves, nightSky]
        return listOfFilters
    }
    
}
