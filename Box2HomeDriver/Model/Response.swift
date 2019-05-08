//
//  Response.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/23/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers
class Response: Object, Codable {
    let code = RealmOptional<Int>()
    dynamic var message: String? = nil
    dynamic var coursesInPipeStats: CoursesInPipeStats?
    dynamic var authToken: AuthToken?
    
    enum CodingKeys: String, CodingKey {
        case code, message, coursesInPipeStats, authToken
    }
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? nil
        self.code.value = try container.decodeIfPresent(Int.self, forKey:.code) ?? nil
        coursesInPipeStats = try container.decodeIfPresent(CoursesInPipeStats.self, forKey: .coursesInPipeStats) ?? nil
        authToken = try container.decodeIfPresent(AuthToken.self, forKey: .authToken) ?? nil
        super.init()
    }
    
    required init(message: String?, coursesInPipeStats: CoursesInPipeStats?, code: Int?, authToken: AuthToken?) {
        self.message = message
        self.coursesInPipeStats = coursesInPipeStats
        self.code.value = code
        self.authToken = authToken
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

extension Response {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Response.self, from: data)
        self.init(message: me.message, coursesInPipeStats: me.coursesInPipeStats, code: me.code.value, authToken: me.authToken)
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
        message: String?? = nil,
        coursesInPipeStats: CoursesInPipeStats?? = nil,
        code: Int?? = nil,
        authToken: AuthToken?? = nil
        ) -> Response {
        return Response(
            message: message ?? self.message,
            coursesInPipeStats: coursesInPipeStats ?? self.coursesInPipeStats,
            code: code ?? self.code.value,
            authToken: authToken ?? self.authToken
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
