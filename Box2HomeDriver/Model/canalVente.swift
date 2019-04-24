////
////  canalVente.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class CanalVente: Decodable {
//    let articleFamilies: [ArticleFamily]
//    let name, code: String
//    let configs: Configs
//
//    init(configs: Configs,code: String, name: String, articleFamilies: [ArticleFamily]) {
//        self.articleFamilies = articleFamilies
//        self.name = name
//        self.code = code
//        self.configs = configs
//    }
//    enum CodingKeys: String, CodingKey {
//        case articleFamilies, name, code, configs
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        articleFamilies = try container.decode([ArticleFamily].self, forKey: .articleFamilies)
//        name = try container.decode(String.self, forKey: .name)
//        code = try container.decode(String.self, forKey: .code)
//        configs = try container.decode(Configs.self, forKey: .configs)
//    }
//}
//
////struct canalVente : Codable{
////    let configs : configs
////    let code : String
////    let name : String
////    let articleFamilies : [articleFamily]
////}

import Foundation

class CanalVente: Codable {
    let articleFamilies: [ArticleFamily]?
    let name, code: String?
    let configs: Configs?
    
    init(articleFamilies: [ArticleFamily]?, name: String?, code: String?, configs: Configs?) {
        self.articleFamilies = articleFamilies
        self.name = name
        self.code = code
        self.configs = configs
    }
}

extension CanalVente {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CanalVente.self, from: data)
        self.init(articleFamilies: me.articleFamilies, name: me.name, code: me.code, configs: me.configs)
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
        articleFamilies: [ArticleFamily]?? = nil,
        name: String?? = nil,
        code: String?? = nil,
        configs: Configs?? = nil
        ) -> CanalVente {
        return CanalVente(
            articleFamilies: articleFamilies ?? self.articleFamilies,
            name: name ?? self.name,
            code: code ?? self.code,
            configs: configs ?? self.configs
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
