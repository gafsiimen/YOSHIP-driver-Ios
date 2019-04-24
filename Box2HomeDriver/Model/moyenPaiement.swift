////
////  moyenPaiement.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class MoyenPaiement: Decodable {
//    let code, label: String
//
//    enum CodingKeys: String, CodingKey {
//        case code, label
//    }
//
//    init(code: String, label: String) {
//        self.code = code
//        self.label = label
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        code = try container.decode(String.self, forKey: .code)
//        label = try container.decode(String.self, forKey: .label)
//    }
//}
////struct moyenPaiement : Codable {
////    let code : String
////    let label : String
////}

import Foundation
class MoyenPaiement: Codable {
    let code, label: String?
    
    init(code: String?, label: String?) {
        self.code = code
        self.label = label
    }
}
extension MoyenPaiement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MoyenPaiement.self, from: data)
        self.init(code: me.code, label: me.label)
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
        label: String?? = nil
        ) -> MoyenPaiement {
        return MoyenPaiement(
            code: code ?? self.code,
            label: label ?? self.label
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
