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
import RealmSwift
import Realm

@objcMembers 
class Chauffeur: Object, Codable {
    let etat = RealmOptional<Int>()
    let manutention = RealmOptional<Bool>()
    let latitude = RealmOptional<Double>()
    let heading = RealmOptional<Int>()
    let moyenneEtoiles = RealmOptional<Double>()
    let onDuty = RealmOptional<Bool>()
    let longitude = RealmOptional<Double>()
    let vehiculeID = RealmOptional<Int>()
    dynamic var phone: String? = nil
    let status = RealmOptional<Int>()
    let id = RealmOptional<Int>()
    dynamic var companyName: String? = nil
    dynamic var avatarURL: String? = nil
    dynamic var vehiculeType: String? = nil
    dynamic var lastLogoutAt: String? = nil
    dynamic var avis: String? = nil
    dynamic var lastLoginAt: String? = nil
    dynamic var immatriculation: String? = nil
    dynamic var deviceInfo: String? = nil
    dynamic var lastname: String? = nil
    dynamic var firstname: String? = nil
    dynamic var code: String? = nil
    var coursesInPipe = RealmSwift.List<String>()
    var vehicules = RealmSwift.List<Vehicule>()

    
    enum CodingKeys: String, CodingKey {
        case etat, manutention, companyName, avatarURL, code, vehiculeType, lastLogoutAt, avis, latitude, heading, lastLoginAt, immatriculation, deviceInfo, moyenneEtoiles, coursesInPipe, firstname, lastname, onDuty, longitude
        case vehiculeID = "vehiculeId"
        case phone, status, vehicules, id
    }
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        companyName = try container.decodeIfPresent(String.self, forKey: .companyName) ?? nil
        avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? nil
        vehiculeType = try container.decodeIfPresent(String.self, forKey: .vehiculeType) ?? nil
        lastLogoutAt = try container.decodeIfPresent(String.self, forKey: .lastLogoutAt) ?? nil
        avis = try container.decodeIfPresent(String.self, forKey: .avis) ?? nil
        lastLoginAt = try container.decodeIfPresent(String.self, forKey: .lastLoginAt) ?? nil
        immatriculation = try container.decodeIfPresent(String.self, forKey: .immatriculation) ?? nil
        deviceInfo = try container.decodeIfPresent(String.self, forKey: .deviceInfo) ?? nil
        phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? nil
        lastname = try container.decodeIfPresent(String.self, forKey: .lastname) ?? nil
        firstname = try container.decodeIfPresent(String.self, forKey: .firstname) ?? nil
        code = try container.decodeIfPresent(String.self, forKey: .code) ?? nil
        self.etat.value = try container.decodeIfPresent(Int.self, forKey:.etat) ?? nil
        self.manutention.value = try container.decodeIfPresent(Bool.self, forKey:.manutention) ?? nil
        self.latitude.value = try container.decodeIfPresent(Double.self, forKey:.latitude) ?? nil
        self.heading.value = try container.decodeIfPresent(Int.self, forKey:.heading) ?? nil
        self.moyenneEtoiles.value = try container.decodeIfPresent(Double.self, forKey:.moyenneEtoiles) ?? nil
        self.onDuty.value = try container.decodeIfPresent(Bool.self, forKey:.onDuty) ?? nil
        self.longitude.value = try container.decodeIfPresent(Double.self, forKey:.longitude) ?? nil
        self.vehiculeID.value = try container.decodeIfPresent(Int.self, forKey:.vehiculeID) ?? nil
        self.status.value = try container.decodeIfPresent(Int.self, forKey:.status) ?? nil
        self.id.value = try container.decodeIfPresent(Int.self, forKey:.id) ?? nil
        coursesInPipe = try container.decodeIfPresent(List<String>.self,forKey: .coursesInPipe) ?? List<String>()
        vehicules = try container.decodeIfPresent(List<Vehicule>.self,forKey: .vehicules) ?? List<Vehicule>()
        super.init()
    }
    
    required init(lastname: String?, firstname: String?, code: String?) {
        self.lastname = lastname
        self.firstname = firstname
        self.code = code
        super.init()
    }
    
    required init(etat: Int?, manutention: Bool?, companyName: String?, avatarURL: String?, code: String?, vehiculeType: String?, lastLogoutAt: String?, avis: String?, latitude: Double?, heading: Int?, lastLoginAt: String?, immatriculation: String?, deviceInfo: String?, moyenneEtoiles: Double?, coursesInPipe: List<String>, firstname: String?, lastname: String?, onDuty: Bool?, longitude: Double?, vehiculeID: Int?, phone: String?, status: Int?, vehicules: List<Vehicule>, id: Int?) {
        self.etat.value = etat
        self.manutention.value = manutention
        self.companyName = companyName
        self.avatarURL = avatarURL
        self.code = code
        self.vehiculeType = vehiculeType
        self.lastLogoutAt = lastLogoutAt
        self.avis = avis
        self.latitude.value = latitude
        self.heading.value = heading
        self.lastLoginAt = lastLoginAt
        self.immatriculation = immatriculation
        self.deviceInfo = deviceInfo
        self.moyenneEtoiles.value = moyenneEtoiles
        self.coursesInPipe = coursesInPipe
        self.firstname = firstname
        self.lastname = lastname
        self.onDuty.value = onDuty
        self.longitude.value = longitude
        self.vehiculeID.value = vehiculeID
        self.phone = phone
        self.status.value = status
        self.vehicules = vehicules
        self.id.value = id
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
   
}

extension Chauffeur {
   
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.companyName, forKey: .companyName)
//        try container.encode(self.avatarURL, forKey: .avatarURL)
//        try container.encode(self.vehiculeType, forKey: .vehiculeType)
//        try container.encode(self.lastname, forKey: .lastname)
//        try container.encode(self.firstname, forKey: .firstname)
//        try container.encode(self.code, forKey: .code)
//        try container.encode(self.longitude, forKey: .longitude)
//        try container.encode(self.latitude, forKey: .latitude)
//        try container.encode(self.id, forKey: .id)
//        try container.encode(self.lastLogoutAt, forKey: .lastLogoutAt)
//        try container.encode(self.avis, forKey: .avis)
//        try container.encode(self.lastLoginAt, forKey: .lastLoginAt)
//        try container.encode(self.immatriculation, forKey: .immatriculation)
//        try container.encode(self.deviceInfo, forKey: .deviceInfo)
//        try container.encode(self.phone, forKey: .phone)
//        try container.encode(self.etat, forKey: .etat)
//        try container.encode(self.manutention, forKey: .manutention)
//        try container.encode(self.heading, forKey: .heading)
//        try container.encode(self.moyenneEtoiles, forKey: .moyenneEtoiles)
//        try container.encode(self.onDuty, forKey: .onDuty)
//        try container.encode(self.vehiculeID, forKey: .vehiculeID)
//        try container.encode(self.status, forKey: .status)
//        let coursesInPipeArray = Array(self.coursesInPipe)
//        try container.encode(coursesInPipeArray, forKey: .coursesInPipe)
//        let vehiculesArray = Array(self.vehicules)
//        try container.encode(vehiculesArray, forKey: .vehicules)
//    }
    
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Chauffeur.self, from: data)
        self.init(etat: me.etat.value, manutention: me.manutention.value, companyName: me.companyName, avatarURL: me.avatarURL, code: me.code, vehiculeType: me.vehiculeType, lastLogoutAt: me.lastLogoutAt, avis: me.avis, latitude: me.latitude.value, heading: me.heading.value, lastLoginAt: me.lastLoginAt, immatriculation: me.immatriculation, deviceInfo: me.deviceInfo, moyenneEtoiles: me.moyenneEtoiles.value, coursesInPipe: me.coursesInPipe, firstname: me.firstname, lastname: me.lastname, onDuty: me.onDuty.value, longitude: me.longitude.value, vehiculeID: me.vehiculeID.value, phone: me.phone, status: me.status.value, vehicules: me.vehicules, id: me.id.value)
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
        coursesInPipe: List<String>? = nil,
        firstname: String?? = nil,
        lastname: String?? = nil,
        onDuty: Bool?? = nil,
        longitude: Double?? = nil,
        vehiculeID: Int?? = nil,
        phone: String?? = nil,
        status: Int?? = nil,
        vehicules: List<Vehicule>? = nil,
        id: Int?? = nil
        ) -> Chauffeur {
        return Chauffeur(
            etat: etat ?? self.etat.value,
            manutention: manutention ?? self.manutention.value,
            companyName: companyName ?? self.companyName,
            avatarURL: avatarURL ?? self.avatarURL,
            code: code ?? self.code,
            vehiculeType: vehiculeType ?? self.vehiculeType,
            lastLogoutAt: lastLogoutAt ?? self.lastLogoutAt,
            avis: avis ?? self.avis,
            latitude: latitude ?? self.latitude.value,
            heading: heading ?? self.heading.value,
            lastLoginAt: lastLoginAt ?? self.lastLoginAt,
            immatriculation: immatriculation ?? self.immatriculation,
            deviceInfo: deviceInfo ?? self.deviceInfo,
            moyenneEtoiles: moyenneEtoiles ?? self.moyenneEtoiles.value,
            coursesInPipe: coursesInPipe ?? self.coursesInPipe,
            firstname: firstname ?? self.firstname,
            lastname: lastname ?? self.lastname,
            onDuty: onDuty ?? self.onDuty.value,
            longitude: longitude ?? self.longitude.value,
            vehiculeID: vehiculeID ?? self.vehiculeID.value,
            phone: phone ?? self.phone,
            status: status ?? self.status.value,
            vehicules: vehicules ?? self.vehicules,
            id: id ?? self.id.value
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
