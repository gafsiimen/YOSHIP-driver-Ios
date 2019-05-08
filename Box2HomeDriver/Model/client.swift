//
//  client.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers
class Client: Object, Codable {
    dynamic var mail: String? = nil
    dynamic var firstname: String? = nil
    dynamic var phone: String? = nil
    dynamic var lastname: String? = nil
    dynamic var avatarURL: String? = nil
    dynamic var societe: Societe?
    
    required init(mail: String?, firstname: String?, phone: String?, lastname: String?, avatarURL: String?, societe: Societe?) {
        self.mail = mail
        self.firstname = firstname
        self.phone = phone
        self.lastname = lastname
        self.avatarURL = avatarURL
        self.societe = societe
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

extension Client {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Client.self, from: data)
        self.init(mail: me.mail, firstname: me.firstname, phone: me.phone, lastname: me.lastname, avatarURL: me.avatarURL, societe: me.societe)
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
        mail: String?? = nil,
        firstname: String?? = nil,
        phone: String?? = nil,
        lastname: String?? = nil,
        avatarURL: String?? = nil,
        societe: Societe?? = nil
        ) -> Client {
        return Client(
            mail: mail ?? self.mail,
            firstname: firstname ?? self.firstname,
            phone: phone ?? self.phone,
            lastname: lastname ?? self.lastname,
            avatarURL: avatarURL ?? self.avatarURL,
            societe: societe ?? self.societe
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
