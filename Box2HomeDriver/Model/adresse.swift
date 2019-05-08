//
//  adresse.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers 
class Adresse: Object, Codable {
    let postalCode = RealmOptional<Int>()
    let longitude = RealmOptional<Double>()
    dynamic var address: String? = nil
    let latitude = RealmOptional<Double>()
    let id = RealmOptional<Int>()
    var operationalHours = RealmSwift.List<OperationalHour>()
    dynamic var label: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case postalCode, longitude, address, latitude, id, operationalHours, label
    }
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decodeIfPresent(String.self, forKey: .address) ?? nil
        label = try container.decodeIfPresent(String.self, forKey: .label) ?? nil
        self.postalCode.value = try container.decodeIfPresent(Int.self, forKey:.postalCode) ?? nil
        self.longitude.value = try container.decodeIfPresent(Double.self, forKey:.longitude) ?? nil
        self.latitude.value = try container.decodeIfPresent(Double.self, forKey:.latitude) ?? nil
        self.id.value = try container.decodeIfPresent(Int.self, forKey:.id) ?? nil
        operationalHours = try container.decodeIfPresent(List<OperationalHour>.self,forKey: .operationalHours) ?? List<OperationalHour>()
        super.init()
    }
    required init(postalCode: Int?, longitude: Double?, address: String?, latitude: Double?, id: Int?, operationalHours: List<OperationalHour>, label: String?) {
        self.postalCode.value = postalCode
        self.longitude.value = longitude
        self.address = address
        self.latitude.value = latitude
        self.id.value = id
        self.operationalHours = operationalHours
        self.label = label
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

extension Adresse {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.address, forKey: .address)
//        try container.encode(self.label, forKey: .label)
//        try container.encode(self.postalCode, forKey: .postalCode)
//        try container.encode(self.longitude, forKey: .longitude)
//        try container.encode(self.latitude, forKey: .latitude)
//        try container.encode(self.id, forKey: .id)
//        let operationalHoursArray = Array(self.operationalHours)
//        try container.encode(operationalHoursArray, forKey: .operationalHours)
//    }
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Adresse.self, from: data)
        self.init(postalCode: me.postalCode.value, longitude: me.longitude.value, address: me.address, latitude: me.latitude.value, id: me.id.value, operationalHours: me.operationalHours, label: me.label)
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
        postalCode: Int?? = nil,
        longitude: Double?? = nil,
        address: String?? = nil,
        latitude: Double?? = nil,
        id: Int?? = nil,
        operationalHours: List<OperationalHour>? = nil,
        label: String?? = nil
        ) -> Adresse {
        return Adresse(
            postalCode: postalCode ?? self.postalCode.value,
            longitude: longitude ?? self.longitude.value,
            address: address ?? self.address,
            latitude: latitude ?? self.latitude.value,
            id: id ?? self.id.value,
            operationalHours: operationalHours ?? self.operationalHours,
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
