////
////  chauffeur.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class Chauffeur : Decodable  {
//    var id : Int?
//    var label : String?
//    var latitude : Double?
//    var longitude : Double?
//    var vehicules : [Vehicule]?
//    var heading : Int?
//    let lastname : String
//    let firstname : String
//    var manutention : Bool?
//    var phone : String?
//    var avatarURL : String?
//    let code : String
//    var companyName : String?
//    var moyenneEtoiles : Double?
//    var avis : String?
//    var immatriculation : String?
//    var onDuty : Bool?
//    var coursesInPipe : [String]?
//    var status : Int?
//    var vehiculeID : Int?
//    var deviceInfo : String?
//    var lastLogoutAt : String?
//    var lastLoginAt : String?
//    var etat : Int?
//    var vehiculeType : String?
//    
//    enum CodingKeys: String, CodingKey {
//        case etat, manutention, companyName, avatarURL, code, vehiculeType, lastLogoutAt, avis, latitude, heading, lastLoginAt, immatriculation, deviceInfo, moyenneEtoiles, coursesInPipe, firstname, lastname, onDuty, longitude
//        case vehiculeID = "vehiculeId"
//        case phone, status, vehicules, id
//    }
//
//    init(id:Int?,label : String?, latitude : Double?, longitude : Double?, vehicules : [Vehicule]?, heading : Int?, lastname : String, firstname : String, manutention : Bool?, phone : String?, avatarURL : String?, code : String, companyName : String?, moyenneEtoiles : Double?, avis : String?, immatriculation : String?, onDuty : Bool?, coursesInPipe : [String]?, status : Int?, vehiculeId : Int?, deviceInfo : String?, lastLogoutAt : String?, lastLoginAt : String?, etat : Int?, vehiculeType : String?) {
//        
//        self.id = id
//        self.label = label
//        self.vehicules = vehicules
//        self.heading = heading
//        self.latitude = latitude
//        self.longitude = longitude
//        self.lastname = lastname
//        self.firstname = firstname
//        self.manutention = manutention
//        self.phone = phone
//        self.avatarURL = avatarURL
//        self.code = code
//        self.companyName = companyName
//        self.moyenneEtoiles = moyenneEtoiles
//        self.avis = avis
//        self.immatriculation = immatriculation
//        self.onDuty = onDuty
//        self.coursesInPipe = coursesInPipe
//        self.status = status
//        self.vehiculeID = vehiculeId
//        self.deviceInfo = deviceInfo
//        self.lastLogoutAt = lastLogoutAt
//        self.lastLoginAt = lastLoginAt
//        self.etat = etat
//        self.vehiculeType = vehiculeType
//    }
//    
//    init(lastname : String, firstname : String, code : String) {
//        self.lastname = lastname
//        self.firstname = firstname
//        self.code = code
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        lastname = try container.decode(String.self, forKey: .lastname)
//        firstname = try container.decode(String.self, forKey: .firstname)
//        code = try container.decode(String.self, forKey: .code)
//
//    }
//}
////
////
////struct chauffeur : Codable  {
////    var id : Int?
////    var label : String?
////    var latitude : Double?
////    var longitude : Double?
////    var vehicules : [vehicule]?
////    var heading : Int?
////    let lastname : String
////    let firstname : String
////    var manutention : Bool?
////    var phone : String?
////    var avatarURL : String?
////    let code : String
////    var companyName : String?
////    var moyenneEtoiles : Double?
////    var avis : String?
////    var immatriculation : String?
////    var onDuty : Bool?
////    var coursesInPipe : [String]?
////    var status : Int?
////    var vehiculeId : Int?
////    var deviceInfo : String?
////    var lastLogoutAt : String?
////    var lastLoginAt : String?
////    var etat : Int?
////    var vehiculeType : String?
//////
////
////    init(id:Int,label : String, latitude : Double, longitude : Double, vehicules : [vehicule], heading : Int, lastname : String, firstname : String, manutention : Bool, phone : String, avatarURL : String, code : String, companyName : String, moyenneEtoiles : Double, avis : String, immatriculation : String, onDuty : Bool, coursesInPipe : [String], status : Int, vehiculeId : Int, deviceInfo : String, lastLogoutAt : String, lastLoginAt : String, etat : Int, vehiculeType : String) {
////
////        self.id = id
////        self.label = label
////        self.vehicules = vehicules
////        self.heading = heading
////        self.latitude = latitude
////        self.longitude = longitude
////        self.lastname = lastname
////        self.firstname = firstname
////        self.manutention = manutention
////        self.phone = phone
////        self.avatarURL = avatarURL
////        self.code = code
////        self.companyName = companyName
////        self.moyenneEtoiles = moyenneEtoiles
////        self.avis = avis
////        self.immatriculation = immatriculation
////        self.onDuty = onDuty
////        self.coursesInPipe = coursesInPipe
////        self.status = status
////        self.vehiculeId = vehiculeId
////        self.deviceInfo = deviceInfo
////        self.lastLogoutAt = lastLogoutAt
////        self.lastLoginAt = lastLoginAt
////        self.etat = etat
////        self.vehiculeType = vehiculeType
////    }
//
////    init(lastname : String, firstname : String, code : String) {
////        self.lastname = lastname
////        self.firstname = firstname
////        self.code = code
////    }
////}

import Foundation

class Chauffeur: Codable {
    var etat: Int?
    var manutention: Bool?
    var companyName: String?
    var avatarURL: String?
    var vehiculeType: String?
    var lastLogoutAt: String?
    var avis: String?
    var latitude: Double?
    var heading: Int?
    var lastLoginAt: String?
    var immatriculation, deviceInfo: String?
    var moyenneEtoiles: Double?
    var coursesInPipe: [String]?
    var onDuty: Bool?
    var longitude: Double?
    var vehiculeID: Int?
    var phone: String?
    var status: Int?
    var vehicules: [Vehicule]?
    var id: Int?
    
    var lastname, firstname, code: String?
    
    enum CodingKeys: String, CodingKey {
        case etat, manutention, companyName, avatarURL, code, vehiculeType, lastLogoutAt, avis, latitude, heading, lastLoginAt, immatriculation, deviceInfo, moyenneEtoiles, coursesInPipe, firstname, lastname, onDuty, longitude
        case vehiculeID = "vehiculeId"
        case phone, status, vehicules, id
    }
    
    init(lastname: String?, firstname: String?, code: String?) {
        self.lastname = lastname
        self.firstname = firstname
        self.code = code
    }
    init(etat: Int?, manutention: Bool?, companyName: String?, avatarURL: String?, code: String?, vehiculeType: String?, lastLogoutAt: String?, avis: String?, latitude: Double?, heading: Int?, lastLoginAt: String?, immatriculation: String?, deviceInfo: String?, moyenneEtoiles: Double?, coursesInPipe: [String]?, firstname: String?, lastname: String?, onDuty: Bool?, longitude: Double?, vehiculeID: Int?, phone: String?, status: Int?, vehicules: [Vehicule]?, id: Int?) {
        self.etat = etat
        self.manutention = manutention
        self.companyName = companyName
        self.avatarURL = avatarURL
        self.code = code
        self.vehiculeType = vehiculeType
        self.lastLogoutAt = lastLogoutAt
        self.avis = avis
        self.latitude = latitude
        self.heading = heading
        self.lastLoginAt = lastLoginAt
        self.immatriculation = immatriculation
        self.deviceInfo = deviceInfo
        self.moyenneEtoiles = moyenneEtoiles
        self.coursesInPipe = coursesInPipe
        self.firstname = firstname
        self.lastname = lastname
        self.onDuty = onDuty
        self.longitude = longitude
        self.vehiculeID = vehiculeID
        self.phone = phone
        self.status = status
        self.vehicules = vehicules
        self.id = id
    }
}

extension Chauffeur {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Chauffeur.self, from: data)
        self.init(etat: me.etat, manutention: me.manutention, companyName: me.companyName, avatarURL: me.avatarURL, code: me.code, vehiculeType: me.vehiculeType, lastLogoutAt: me.lastLogoutAt, avis: me.avis, latitude: me.latitude, heading: me.heading, lastLoginAt: me.lastLoginAt, immatriculation: me.immatriculation, deviceInfo: me.deviceInfo, moyenneEtoiles: me.moyenneEtoiles, coursesInPipe: me.coursesInPipe, firstname: me.firstname, lastname: me.lastname, onDuty: me.onDuty, longitude: me.longitude, vehiculeID: me.vehiculeID, phone: me.phone, status: me.status, vehicules: me.vehicules, id: me.id)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        etat: Int?? = nil,
        manutention: Bool?? = nil,
        companyName: String?? = nil,
        avatarURL: String?? = nil,
        code: String?? = nil,
        vehiculeType: String?? = nil,
        lastLogoutAt: String?? = nil,
        avis: String?? = nil,
        latitude: Double?? = nil,
        heading: Int?? = nil,
        lastLoginAt: String?? = nil,
        immatriculation: String?? = nil,
        deviceInfo: String?? = nil,
        moyenneEtoiles: Double?? = nil,
        coursesInPipe: [String]?? = nil,
        firstname: String?? = nil,
        lastname: String?? = nil,
        onDuty: Bool?? = nil,
        longitude: Double?? = nil,
        vehiculeID: Int?? = nil,
        phone: String?? = nil,
        status: Int?? = nil,
        vehicules: [Vehicule]?? = nil,
        id: Int?? = nil
        ) -> Chauffeur {
        return Chauffeur(
            etat: etat ?? self.etat,
            manutention: manutention ?? self.manutention,
            companyName: companyName ?? self.companyName,
            avatarURL: avatarURL ?? self.avatarURL,
            code: code ?? self.code,
            vehiculeType: vehiculeType ?? self.vehiculeType,
            lastLogoutAt: lastLogoutAt ?? self.lastLogoutAt,
            avis: avis ?? self.avis,
            latitude: latitude ?? self.latitude,
            heading: heading ?? self.heading,
            lastLoginAt: lastLoginAt ?? self.lastLoginAt,
            immatriculation: immatriculation ?? self.immatriculation,
            deviceInfo: deviceInfo ?? self.deviceInfo,
            moyenneEtoiles: moyenneEtoiles ?? self.moyenneEtoiles,
            coursesInPipe: coursesInPipe ?? self.coursesInPipe,
            firstname: firstname ?? self.firstname,
            lastname: lastname ?? self.lastname,
            onDuty: onDuty ?? self.onDuty,
            longitude: longitude ?? self.longitude,
            vehiculeID: vehiculeID ?? self.vehiculeID,
            phone: phone ?? self.phone,
            status: status ?? self.status,
            vehicules: vehicules ?? self.vehicules,
            id: id ?? self.id
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
