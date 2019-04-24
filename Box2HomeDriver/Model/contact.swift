////
////  contact.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class Contact: Decodable {
//    let firstname : String
//    let lastname : String
//    let phone : String
//    let mail : String
//
//
//    init(firstname : String, lastname : String, phone : String, mail : String) {
//    self.firstname = firstname
//    self.lastname = lastname
//    self.phone = phone
//    self.mail = mail
//    }
//    enum CodingKeys: String, CodingKey {
//        case firstname, lastname, phone, mail
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        firstname = try container.decode(String.self, forKey: .firstname)
//        lastname = try container.decode(String.self, forKey: .lastname)
//        phone = try container.decode(String.self, forKey: .phone)
//        mail = try container.decode(String.self, forKey: .mail)
//    }
//}
////struct contact : Codable{
////    let firstname : String
////    let lastname : String
////    let phone : String
////    let mail : String
////}

import Foundation

class Contact: Codable {
    let firstname, lastname, phone, mail: String?
    
    init(firstname: String?, lastname: String?, phone: String?, mail: String?) {
        self.firstname = firstname
        self.lastname = lastname
        self.phone = phone
        self.mail = mail
    }
}

extension Contact {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Contact.self, from: data)
        self.init(firstname: me.firstname, lastname: me.lastname, phone: me.phone, mail: me.mail)
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
        firstname: String?? = nil,
        lastname: String?? = nil,
        phone: String?? = nil,
        mail: String?? = nil
        ) -> Contact {
        return Contact(
            firstname: firstname ?? self.firstname,
            lastname: lastname ?? self.lastname,
            phone: phone ?? self.phone,
            mail: mail ?? self.mail
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
