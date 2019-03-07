//
//  chauffeur.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
struct chauffeur  {
    let id : Int
    let label : String
    let latitude : Double
    let longitude : Double
    let vehicules : [vehicule]
    let heading : Int
    let lastname : String
    let firstname : String
    let manutention : Bool
    let phone : String
    let avatarURL : String
    let code : String
    let companyName : String
    let moyenneEtoiles : Float
    let avis : String
    let immatriculation : String
    let onDuty : Bool
    let coursesInPipe : [String]
    let status : Int
    let vehiculeId : Int
    let deviceInfo : String
    let lastLogoutAt : String
    let lastLoginAt : String
    let etat : Int
    let vehiculeType : String
    

    init(id:Int,label : String, latitude : Double, longitude : Double, vehicules : [vehicule], heading : Int, lastname : String, firstname : String, manutention : Bool, phone : String, avatarURL : String, code : String, companyName : String, moyenneEtoiles : Float, avis : String, immatriculation : String, onDuty : Bool, coursesInPipe : [String], status : Int, vehiculeId : Int, deviceInfo : String, lastLogoutAt : String, lastLoginAt : String, etat : Int, vehiculeType : String) {

        self.id = id
        self.label = label
        self.vehicules = vehicules
        self.heading = heading
        self.latitude = latitude
        self.longitude = longitude
        self.lastname = lastname
        self.firstname = firstname
        self.manutention = manutention
        self.phone = phone
        self.avatarURL = avatarURL
        self.code = code
        self.companyName = companyName
        self.moyenneEtoiles = moyenneEtoiles
        self.avis = avis
        self.immatriculation = immatriculation
        self.onDuty = onDuty
        self.coursesInPipe = coursesInPipe
        self.status = status
        self.vehiculeId = vehiculeId
        self.deviceInfo = deviceInfo
        self.lastLogoutAt = lastLogoutAt
        self.lastLoginAt = lastLoginAt
        self.etat = etat
        self.vehiculeType = vehiculeType
    }

    
}
