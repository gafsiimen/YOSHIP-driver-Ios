//
//  chauffeur.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
struct chauffeur  {
    var id : Int?
    var label : String?
    var latitude : Double?
    var longitude : Double?
    var vehicules : [vehicule]?
    var heading : Int?
    let lastname : String
    let firstname : String
    var manutention : Bool?
    var phone : String?
    var avatarURL : String?
    let code : String
    var companyName : String?
    var moyenneEtoiles : Double?
    var avis : String?
    var immatriculation : String?
    var onDuty : Bool?
    var coursesInPipe : [String]?
    var status : Int?
    var vehiculeId : Int?
    var deviceInfo : String?
    var lastLogoutAt : String?
    var lastLoginAt : String?
    var etat : Int?
    var vehiculeType : String?
    

    init(id:Int,label : String, latitude : Double, longitude : Double, vehicules : [vehicule], heading : Int, lastname : String, firstname : String, manutention : Bool, phone : String, avatarURL : String, code : String, companyName : String, moyenneEtoiles : Double, avis : String, immatriculation : String, onDuty : Bool, coursesInPipe : [String], status : Int, vehiculeId : Int, deviceInfo : String, lastLogoutAt : String, lastLoginAt : String, etat : Int, vehiculeType : String) {

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

    init(lastname : String, firstname : String, code : String) {
        self.lastname = lastname
        self.firstname = firstname
        self.code = code
    }
}
