//
//  vehicule.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
struct vehicule  {
    let id : Int
    let status : Int
    let vehicule_category : Vehicule_category
    let haillon : Bool
    let denomination : String
    let immatriculation : String
    
    init(id : Int, status : Int, vehicule_category : Vehicule_category, haillon : Bool, denomination : String, immatriculation : String) {
        self.id = id
        self.status = status
        self.vehicule_category = vehicule_category
        self.haillon = haillon
        self.denomination = denomination
        self.immatriculation = immatriculation
    }

}
