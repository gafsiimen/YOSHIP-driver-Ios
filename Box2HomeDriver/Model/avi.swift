//
//  avi.swift
//  Box2HomeDriver
//
//  Created by MacHD on 5/9/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers
class Avi: Object, Codable {
     dynamic var commentaire: String?
     dynamic var createdAt: String?
     dynamic var client: Client?
    
    enum CodingKeys: String, CodingKey {
        case commentaire, createdAt, client
    }
    
   required init(commentaire: String?, createdAt: String?, client: Client?) {
        self.commentaire = commentaire
        self.createdAt = createdAt
        self.client = client
        super.init()
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        commentaire = try container.decodeIfPresent(String.self, forKey: .commentaire) ?? nil
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? nil
        client = try container.decodeIfPresent(Client.self, forKey: .client) ?? nil
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
extension Avi {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Avi.self, from: data)
        self.init(commentaire: me.commentaire, createdAt: me.createdAt, client: me.client)
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
        commentaire: String?? = nil,
        createdAt: String?? = nil,
        client: Client?? = nil
        ) -> Avi {
        return Avi(
            commentaire: commentaire ?? self.commentaire,
            createdAt: createdAt ?? self.createdAt,
            client: client ?? self.client
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
