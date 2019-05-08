//
//  coursesInPipeStats.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/1/19.
//  Copyright © 2019 MacHD. All rights reserved.
//


import Foundation
import Realm
import RealmSwift

@objcMembers
class CoursesInPipeStats: Object, Codable {
    let assigned = RealmOptional<Int>()
    let inprogress = RealmOptional<Int>()
    
    enum CodingKeys: String, CodingKey {
        case assigned = "ASSIGNED"
        case inprogress = "INPROGRESS"
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        assigned.value = try container.decodeIfPresent(Int.self, forKey: .assigned) ?? nil
        inprogress.value = try container.decodeIfPresent(Int.self, forKey: .inprogress) ?? nil
        super.init()
    }
    
    required init(assigned: Int?, inprogress: Int?) {
        self.assigned.value = assigned
        self.inprogress.value = inprogress
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


extension CoursesInPipeStats {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CoursesInPipeStats.self, from: data)
        self.init(assigned: me.assigned.value, inprogress: me.inprogress.value)
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
        assigned: Int?? = nil,
        inprogress: Int?? = nil
        ) -> CoursesInPipeStats {
        return CoursesInPipeStats(
            assigned: assigned ?? self.assigned.value,
            inprogress: inprogress ?? self.inprogress.value
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

