//
//  operationalHours.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/12/19.
//  Copyright © 2019 MacHD. All rights reserved.
//


import Foundation
import RealmSwift
import Realm

@objcMembers
class OperationalHour: Object, Codable {
    let deliveryWindow = RealmOptional<Int>()
    dynamic var closeTime: String? = nil
    dynamic var openTime: String? = nil
    dynamic var dayOfWeek: DayOfWeek?
    
    enum CodingKeys: String, CodingKey {
        case deliveryWindow, closeTime, openTime, dayOfWeek
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        openTime = try container.decodeIfPresent(String.self, forKey: .openTime) ?? nil
        closeTime = try container.decodeIfPresent(String.self, forKey: .closeTime) ?? nil
        self.deliveryWindow.value = try container.decodeIfPresent(Int.self, forKey:.deliveryWindow) ?? nil
        dayOfWeek = try container.decodeIfPresent(DayOfWeek.self, forKey: .dayOfWeek) ?? nil
        super.init()
    }
    
    required init(deliveryWindow: Int?, closeTime: String?, openTime: String?, dayOfWeek: DayOfWeek?) {
        self.deliveryWindow.value = deliveryWindow
        self.closeTime = closeTime
        self.openTime = openTime
        self.dayOfWeek = dayOfWeek
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

extension OperationalHour {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(OperationalHour.self, from: data)
        self.init(deliveryWindow: me.deliveryWindow.value, closeTime: me.closeTime, openTime: me.openTime, dayOfWeek: me.dayOfWeek)
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
        deliveryWindow: Int?? = nil,
        closeTime: String?? = nil,
        openTime: String?? = nil,
        dayOfWeek: DayOfWeek?? = nil
        ) -> OperationalHour {
        return OperationalHour(
            deliveryWindow: deliveryWindow ?? self.deliveryWindow.value,
            closeTime: closeTime ?? self.closeTime,
            openTime: openTime ?? self.openTime,
            dayOfWeek: dayOfWeek ?? self.dayOfWeek
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
