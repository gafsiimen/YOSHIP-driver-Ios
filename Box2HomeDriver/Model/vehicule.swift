////
////  vehicule.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class Vehicule: Decodable {
//    let haillon: Bool
//    let vehiculeCategory: VehiculeCategory
//    let id: Int
//    let denomination, immatriculation: String
//    let status: Int
//
//    enum CodingKeys: String, CodingKey {
//        case haillon
//        case vehiculeCategory = "vehicule_category"
//        case id, denomination, immatriculation, status
//    }
//
//    init(haillon: Bool, vehiculeCategory: VehiculeCategory, id: Int, denomination: String, immatriculation: String, status: Int) {
//        self.haillon = haillon
//        self.vehiculeCategory = vehiculeCategory
//        self.id = id
//        self.denomination = denomination
//        self.immatriculation = immatriculation
//        self.status = status
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        haillon = try container.decode(Bool.self, forKey: .haillon)
//        vehiculeCategory = try container.decode(VehiculeCategory.self, forKey: .vehiculeCategory)
//        id = try container.decode(Int.self, forKey: .id)
//        denomination = try container.decode(String.self, forKey: .denomination)
//        immatriculation = try container.decode(String.self, forKey: .immatriculation)
//        status = try container.decode(Int.self, forKey: .status)
//
//    }
//}
//
//

import Foundation

class Vehicule: Codable {
    let denomination: String?
    let haillon: Bool?
    let immatriculation: String?
    let id, status: Int?
    let vehiculeCategory: VehiculeCategory?
    
    enum CodingKeys: String, CodingKey {
        case denomination, haillon, immatriculation, id, status
        case vehiculeCategory = "vehicule_category"
    }
    
    init(denomination: String?, haillon: Bool?, immatriculation: String?, id: Int?, status: Int?, vehiculeCategory: VehiculeCategory?) {
        self.denomination = denomination
        self.haillon = haillon
        self.immatriculation = immatriculation
        self.id = id
        self.status = status
        self.vehiculeCategory = vehiculeCategory
    }
}

extension Vehicule {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Vehicule.self, from: data)
        self.init(denomination: me.denomination, haillon: me.haillon, immatriculation: me.immatriculation, id: me.id, status: me.status, vehiculeCategory: me.vehiculeCategory)
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
        denomination: String?? = nil,
        haillon: Bool?? = nil,
        immatriculation: String?? = nil,
        id: Int?? = nil,
        status: Int?? = nil,
        vehiculeCategory: VehiculeCategory?? = nil
        ) -> Vehicule {
        return Vehicule(
            denomination: denomination ?? self.denomination,
            haillon: haillon ?? self.haillon,
            immatriculation: immatriculation ?? self.immatriculation,
            id: id ?? self.id,
            status: status ?? self.status,
            vehiculeCategory: vehiculeCategory ?? self.vehiculeCategory
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
