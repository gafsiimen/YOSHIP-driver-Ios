////
////  SignatureImage.swift
////  Box2HomeDriver
////
////  Created by MacHD on 3/25/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class SignatureImage: Decodable {
//    let type, url: String
//    init(type: String, url: String) {
//        self.type = type
//        self.url = url
//    }
//    enum CodingKeys: String, CodingKey {
//        case type, url
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        type = try container.decode(String.self, forKey: .type)
//        url = try container.decode(String.self, forKey: .url)
//    }
//}
////struct signatureImage : Codable {
////    let type : String
////    let url : String
////
////    init(type : String, url : String) {
////        self.type = type
////        self.url = url
////    }
////}
//

import Foundation

class SignatureImage: Codable {
    let type, url: String?
    
    init(type: String?, url: String?) {
        self.type = type
        self.url = url
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
