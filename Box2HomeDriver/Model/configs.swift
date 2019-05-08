//
//  configs.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers
class Configs: Object, Codable {
    let priceBasedOnWeight = RealmOptional<Bool>()
    let priceBasedOnNBitems = RealmOptional<Bool>()
    let priceBasedOnPurchaseAmount = RealmOptional<Bool>()
    let fixedPriceIncludeManutention = RealmOptional<Bool>()
    var operationalHours = RealmSwift.List<OperationalHour>()
    
    enum CodingKeys: String, CodingKey {
        case priceBasedOnWeight, priceBasedOnNBitems, priceBasedOnPurchaseAmount, fixedPriceIncludeManutention, operationalHours
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        priceBasedOnWeight.value = try container.decodeIfPresent(Bool.self, forKey: .priceBasedOnWeight) ?? nil
        priceBasedOnNBitems.value = try container.decodeIfPresent(Bool.self, forKey: .priceBasedOnNBitems) ?? nil
        priceBasedOnPurchaseAmount.value = try container.decodeIfPresent(Bool.self, forKey: .priceBasedOnPurchaseAmount) ?? nil
        fixedPriceIncludeManutention.value = try container.decodeIfPresent(Bool.self, forKey: .fixedPriceIncludeManutention) ?? nil
        operationalHours = try container.decodeIfPresent(List<OperationalHour>.self,forKey: .operationalHours) ?? List<OperationalHour>()
        super.init()
    }
    
    init(priceBasedOnWeight: Bool?, operationalHours: List<OperationalHour>, priceBasedOnNBitems: Bool?, priceBasedOnPurchaseAmount: Bool?, fixedPriceIncludeManutention: Bool?) {
        self.priceBasedOnWeight.value = priceBasedOnWeight
        self.operationalHours = operationalHours
        self.priceBasedOnNBitems.value = priceBasedOnNBitems
        self.priceBasedOnPurchaseAmount.value = priceBasedOnPurchaseAmount
        self.fixedPriceIncludeManutention.value = fixedPriceIncludeManutention
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


extension Configs {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Configs.self, from: data)
        self.init(priceBasedOnWeight: me.priceBasedOnWeight.value, operationalHours: me.operationalHours, priceBasedOnNBitems: me.priceBasedOnNBitems.value, priceBasedOnPurchaseAmount: me.priceBasedOnPurchaseAmount.value, fixedPriceIncludeManutention: me.fixedPriceIncludeManutention.value)
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
        priceBasedOnWeight: Bool?? = nil,
        operationalHours: List<OperationalHour>? = nil,
        priceBasedOnNBitems: Bool?? = nil,
        priceBasedOnPurchaseAmount: Bool?? = nil,
        fixedPriceIncludeManutention: Bool?? = nil
        ) -> Configs {
        return Configs(
            priceBasedOnWeight: priceBasedOnWeight ?? self.priceBasedOnWeight.value,
            operationalHours: operationalHours ?? self.operationalHours,
            priceBasedOnNBitems: priceBasedOnNBitems ?? self.priceBasedOnNBitems.value,
            priceBasedOnPurchaseAmount: priceBasedOnPurchaseAmount ?? self.priceBasedOnPurchaseAmount.value,
            fixedPriceIncludeManutention: fixedPriceIncludeManutention ?? self.fixedPriceIncludeManutention.value
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
