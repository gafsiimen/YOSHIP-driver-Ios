//
//  vehicule_category.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers
class VehiculeCategory: Object, Codable {
    let volumeMax = RealmOptional<Int>()
    let id = RealmOptional<Int>()
    dynamic var type: String? = nil
    dynamic var code: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, volumeMax, type, code
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id.value = try container.decodeIfPresent(Int.self, forKey:.id) ?? nil
        self.volumeMax.value = try container.decodeIfPresent(Int.self, forKey:.volumeMax) ?? nil
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? nil
        code = try container.decodeIfPresent(String.self, forKey: .code) ?? nil
        super.init()
    }

    
   required init(type: String?, volumeMax: Int?, code: String?, id: Int?) {
        self.type = type
        self.volumeMax.value = volumeMax
        self.code = code
        self.id.value = id
        super.init()
    }
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
}


extension VehiculeCategory {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(VehiculeCategory.self, from: data)
        self.init(type: me.type, volumeMax: me.volumeMax.value, code: me.code, id: me.id.value)
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
            volumeMax: volumeMax ?? self.volumeMax.value,
            code: code ?? self.code,
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
