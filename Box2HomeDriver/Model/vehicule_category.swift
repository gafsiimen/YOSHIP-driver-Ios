//
//  vehicule_category.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
struct Vehicule_category  {
    let code : String
    let type : String
    let volumeMax : Int
    var id : Int?
    
    init( code : String, type : String, volumeMax : Int, id : Int) {
        self.code = code
        self.type = type
        self.volumeMax = volumeMax
        self.id = id
    }
    init( code : String, type : String, volumeMax : Int) {
        self.code = code
        self.type = type
        self.volumeMax = volumeMax
    
    }
}
