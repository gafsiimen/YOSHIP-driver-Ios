////
////  collaborateur.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
////class Collaborateur: Codable {
////
////    init() {
////    }
////}
//class Collaborateur: Decodable {
//    let lastname : String
//    let firstname : String
//    init(lastname : String, firstname : String) {
//        self.firstname = firstname
//        self.lastname = lastname
//    }
//    enum CodingKeys: String, CodingKey {
//        case lastname, firstname
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        lastname = try container.decode(String.self, forKey: .lastname)
//        firstname = try container.decode(String.self, forKey: .firstname)
//    }
//}
////struct collaborateur : Codable {
////    let lastname : String
////    let firstname : String
////}

import Foundation

class Collaborateur: Codable {
    let lastname, firstname: String?
    
    init(lastname: String?, firstname: String?) {
        self.lastname = lastname
        self.firstname = firstname
    }
}

extension Collaborateur {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Collaborateur.self, from: data)
        self.init(lastname: me.lastname, firstname: me.firstname)
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
        lastname: String?? = nil,
        firstname: String?? = nil
        ) -> Collaborateur {
        return Collaborateur(
            lastname: lastname ?? self.lastname,
            firstname: firstname ?? self.firstname
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
