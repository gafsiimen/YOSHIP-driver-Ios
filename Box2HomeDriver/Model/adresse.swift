////
////  adresse.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class Adresse: Decodable {
//    let id : Int
//    let label : String
//    let address : String
//    let latitude : Double
//    let longitude : Double
//    let postalCode : Int
//    let operationalHours : [OperationalHours]
//
//    enum CodingKeys: String, CodingKey {
//        case id, label, address, latitude, longitude, postalCode, operationalHours
//    }
//    
//    init(id : Int,label : String,address : String,latitude : Double,longitude : Double,postalCode : Int, operationalHours : [OperationalHours]) {
//        self.postalCode = postalCode
//        self.longitude = longitude
//        self.address = address
//        self.latitude = latitude
//        self.id = id
//        self.operationalHours = operationalHours
//        self.label = label
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        label = try container.decode(String.self, forKey: .label)
//        address = try container.decode(String.self, forKey: .address)
//        latitude = try container.decode(Double.self, forKey: .latitude)
//        longitude = try container.decode(Double.self, forKey: .longitude)
//        postalCode = try container.decode(Int.self, forKey: .postalCode)
//        operationalHours = try container.decode([OperationalHours].self, forKey: .operationalHours)
//    }
//}
////struct adresse : Codable {
////    let id : Int
////    let label : String
////    let address : String
////    let latitude : Double
////    let longitude : Double
////    let postalCode : Int
////    let operationalHours : [operationalHours]
////}


import Foundation

class Adresse: Codable {
    let postalCode: Int?
    let longitude: Double?
    let address: String?
    let latitude: Double?
    let id: Int?
    let operationalHours: [OperationalHour]?
    let label: String?
    
    init(postalCode: Int?, longitude: Double?, address: String?, latitude: Double?, id: Int?, operationalHours: [OperationalHour]?, label: String?) {
        self.postalCode = postalCode
        self.longitude = longitude
        self.address = address
        self.latitude = latitude
        self.id = id
        self.operationalHours = operationalHours
        self.label = label
    }
}

extension Adresse {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Adresse.self, from: data)
        self.init(postalCode: me.postalCode, longitude: me.longitude, address: me.address, latitude: me.latitude, id: me.id, operationalHours: me.operationalHours, label: me.label)
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
        postalCode: Int?? = nil,
        longitude: Double?? = nil,
        address: String?? = nil,
        latitude: Double?? = nil,
        id: Int?? = nil,
        operationalHours: [OperationalHour]?? = nil,
        label: String?? = nil
        ) -> Adresse {
        return Adresse(
            postalCode: postalCode ?? self.postalCode,
            longitude: longitude ?? self.longitude,
            address: address ?? self.address,
            latitude: latitude ?? self.latitude,
            id: id ?? self.id,
            operationalHours: operationalHours ?? self.operationalHours,
            label: label ?? self.label
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
