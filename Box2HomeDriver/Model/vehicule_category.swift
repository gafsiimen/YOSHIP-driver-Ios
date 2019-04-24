////
////  vehicule_category.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class VehiculeCategory: Decodable {
//    let code: String
//    let type: String
//    let volumeMax: Int
//    var id: Int?
//
//    init(code: String, type: String, volumeMax: Int,  id: Int) {
//        self.code = code
//        self.volumeMax = volumeMax
//        self.type = type
//        self.id = id
//    }
//    init( code : String, type : String, volumeMax : Int) {
//        self.code = code
//        self.type = type
//        self.volumeMax = volumeMax
//    }
//    enum CodingKeys: String, CodingKey {
//        case code, volumeMax, type, id
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        code = try container.decode(String.self, forKey: .code)
//        volumeMax = try container.decode(Int.self, forKey: .volumeMax)
//        type = try container.decode(String.self, forKey: .type)
//        id = try container.decode(Int.self, forKey: .id)
//    }
//
//}
////struct VehiculeCategory : Codable {
////    let code : String
////    let type : String
////    let volumeMax : Int
////    var id : Int?
////
////    init( code : String, type : String, volumeMax : Int, id : Int?) {
////        self.code = code
////        self.type = type
////        self.volumeMax = volumeMax
////        self.id = id
////    }
////    init( code : String, type : String, volumeMax : Int) {
////        self.code = code
////        self.type = type
////        self.volumeMax = volumeMax
////    }
////}

import Foundation

class VehiculeCategory: Codable {
    let type: String?
    let volumeMax: Int?
    let code: String?
    let id: Int?
    
    init(type: String?, volumeMax: Int?, code: String?, id: Int?) {
        self.type = type
        self.volumeMax = volumeMax
        self.code = code
        self.id = id
    }
}


extension VehiculeCategory {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(VehiculeCategory.self, from: data)
        self.init(type: me.type, volumeMax: me.volumeMax, code: me.code, id: me.id)
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
        type: String?? = nil,
        volumeMax: Int?? = nil,
        code: String?? = nil,
        id: Int?? = nil
        ) -> VehiculeCategory {
        return VehiculeCategory(
            type: type ?? self.type,
            volumeMax: volumeMax ?? self.volumeMax,
            code: code ?? self.code,
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
