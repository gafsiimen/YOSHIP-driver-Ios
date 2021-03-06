////
////  lettreDeVoiture.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class LettreDeVoiture: Decodable {
//    let id: Int
//    let code, reference: String
//
//    init(id: Int, code: String, reference: String) {
//        self.id = id
//        self.code = code
//        self.reference = reference
//    }
//    enum CodingKeys: String, CodingKey {
//        case id, code, reference
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        code = try container.decode(String.self, forKey: .code)
//        reference = try container.decode(String.self, forKey: .reference)
//
//    }
//}
////struct lettreDeVoiture : Codable{
////    let id : Int
////    let code : String
////    let reference : String
////}

import Foundation
import RealmSwift
import Realm

@objcMembers
class LettreDeVoiture: Object, Codable {
    let id = RealmOptional<Int>()
    dynamic var code: String? = nil
    dynamic var reference: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, code, reference
    }
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id.value = try container.decodeIfPresent(Int.self, forKey: .id) ?? nil
        code = try container.decodeIfPresent(String.self, forKey: .code) ?? nil
        reference = try container.decodeIfPresent(String.self, forKey: .reference) ?? nil
        super.init()
    }
    required init(id: Int?, code: String?, reference: String?) {
        self.id.value = id
        self.code = code
        self.reference = reference
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



extension LettreDeVoiture {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(LettreDeVoiture.self, from: data)
        self.init(id: me.id.value, code: me.code, reference: me.reference)
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
        id: Int?? = nil,
        code: String?? = nil,
        reference: String?? = nil
        ) -> LettreDeVoiture {
        return LettreDeVoiture(
            id: id ?? self.id.value,
            code: code ?? self.code,
            reference: reference ?? self.reference
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
