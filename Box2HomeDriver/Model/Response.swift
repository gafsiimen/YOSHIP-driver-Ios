//
//  Response.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/23/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation

class Response: Codable {
    let message: String?
    let coursesInPipeStats: CoursesInPipeStats?
    let code: Int?
    let authToken: AuthToken?
    
    init(message: String?, coursesInPipeStats: CoursesInPipeStats?, code: Int?, authToken: AuthToken?) {
        self.message = message
        self.coursesInPipeStats = coursesInPipeStats
        self.code = code
        self.authToken = authToken
    }
}

extension Response {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Response.self, from: data)
        self.init(message: me.message, coursesInPipeStats: me.coursesInPipeStats, code: me.code, authToken: me.authToken)
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
            code: code ?? self.code,
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
