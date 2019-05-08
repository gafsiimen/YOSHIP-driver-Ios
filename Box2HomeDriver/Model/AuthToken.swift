//
//  AuthToken.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/23/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers
class AuthToken: Object, Codable {
    dynamic var value: String? = nil
    dynamic var chauffeur: Chauffeur?
    
    enum CodingKeys: String, CodingKey {
        case value, chauffeur
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decodeIfPresent(String.self, forKey: .value) ?? nil
        chauffeur = try container.decodeIfPresent(Chauffeur.self, forKey: .chauffeur) ?? nil
        super.init()
    }
    required init(value: String?, chauffeur: Chauffeur?) {
        self.value = value
        self.chauffeur = chauffeur
        super.init()
    }
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}


extension AuthToken {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(AuthToken.self, from: data)
        self.init(value: me.value, chauffeur: me.chauffeur)
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
        value: String?? = nil,
        chauffeur: Chauffeur?? = nil
        ) -> AuthToken {
        return AuthToken(
            value: value ?? self.value,
            chauffeur: chauffeur ?? self.chauffeur
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
