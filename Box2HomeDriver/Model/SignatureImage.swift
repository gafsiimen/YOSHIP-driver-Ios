//
//  SignatureImage.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/25/19.
//  Copyright © 2019 MacHD. All rights reserved.
//


import Foundation
import RealmSwift
import Realm

@objcMembers
class SignatureImage: Object, Codable {
    dynamic var type: String? = nil
    dynamic var url: String? = nil
    
    required init(type: String?, url: String?) {
        self.type = type
        self.url = url
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
extension SignatureImage {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SignatureImage.self, from: data)
        self.init(type: me.type, url: me.url)
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
        url: String?? = nil
        ) -> SignatureImage {
        return SignatureImage(
            type: type ?? self.type,
            url: url ?? self.url
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
