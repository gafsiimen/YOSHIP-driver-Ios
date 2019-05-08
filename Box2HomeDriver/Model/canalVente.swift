//
//  canalVente.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers
class CanalVente: Object, Codable {
    var articleFamilies = RealmSwift.List<ArticleFamily>()
    dynamic var configs: Configs?
    dynamic var name: String? = nil
    dynamic var code: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case articleFamilies, configs, name, code
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? nil
        code = try container.decodeIfPresent(String.self, forKey: .code) ?? nil
        configs = try container.decodeIfPresent(Configs.self, forKey: .configs) ?? nil
        articleFamilies = try container.decodeIfPresent(List<ArticleFamily>.self,forKey: .articleFamilies) ?? List<ArticleFamily>()

        super.init()
    }
    
    required init(articleFamilies: List<ArticleFamily>, name: String?, code: String?, configs: Configs?) {
        self.articleFamilies = articleFamilies
        self.name = name
        self.code = code
        self.configs = configs
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
        articleFamilies: List<ArticleFamily>? = nil,
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
