////
////  status.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class Status: Decodable {
//    var color, code, label: String
//
//    init(color: String, code: String, label: String) {
//        self.code = code
//        self.label = label
//        self.color = color
//    }
//    enum CodingKeys: String, CodingKey {
//        case color, code, label
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        color = try container.decode(String.self, forKey: .color)
//        code = try container.decode(String.self, forKey: .code)
//        label = try container.decode(String.self, forKey: .label)
//    }
//}
////struct status : Codable {
////    let color : String
////    var code : String
////    var label : String
////}

import Foundation

class Status: Codable {
    var code, label, color: String?
    
    init(code: String?, label: String?, color: String?) {
        self.code = code
        self.label = label
        self.color = color
    }
}


extension Status {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Status.self, from: data)
        self.init(code: me.code, label: me.label, color: me.color)
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
        code: String?? = nil,
        label: String?? = nil,
        color: String?? = nil
        ) -> Status {
        return Status(
            code: code ?? self.code,
            label: label ?? self.label,
            color: color ?? self.color
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
