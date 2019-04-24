////
////  configs.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class Configs: Decodable {
//    var operationalHours : [OperationalHours]?
//    let priceBasedOnWeight, priceBasedOnNBitems, priceBasedOnPurchaseAmount, fixedPriceIncludeManutention: Bool
//
//    init(operationalHours : [OperationalHours]?, priceBasedOnWeight : Bool, priceBasedOnNBitems : Bool, priceBasedOnPurchaseAmount : Bool, fixedPriceIncludeManutention : Bool) {
//        self.priceBasedOnWeight = priceBasedOnWeight
//        self.priceBasedOnPurchaseAmount = priceBasedOnPurchaseAmount
//        self.priceBasedOnNBitems = priceBasedOnNBitems
//        self.fixedPriceIncludeManutention = fixedPriceIncludeManutention
//        self.operationalHours = operationalHours
//    }
//    enum CodingKeys: String, CodingKey {
//        case operationalHours, priceBasedOnWeight, priceBasedOnNBitems, priceBasedOnPurchaseAmount, fixedPriceIncludeManutention
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        operationalHours = try container.decode([OperationalHours].self, forKey: .operationalHours)
//        priceBasedOnWeight = try container.decode(Bool.self, forKey: .priceBasedOnWeight)
//        priceBasedOnNBitems = try container.decode(Bool.self, forKey: .priceBasedOnNBitems)
//        priceBasedOnPurchaseAmount = try container.decode(Bool.self, forKey: .priceBasedOnPurchaseAmount)
//        fixedPriceIncludeManutention = try container.decode(Bool.self, forKey: .fixedPriceIncludeManutention)
//    }
//}
////struct Configs : Codable{
////    let priceBasedOnPurchaseAmount : Bool
////    let priceBasedOnNBitems : Bool
////    let fixedPriceIncludeManutention : Bool
////    var operationalHours : [operationalHours]?
////
////    init(priceBasedOnPurchaseAmount : Bool, priceBasedOnNBitems : Bool,fixedPriceIncludeManutention : Bool,operationalHours : [operationalHours]) {
////        self.priceBasedOnPurchaseAmount = priceBasedOnPurchaseAmount
////        self.priceBasedOnNBitems = priceBasedOnNBitems
////        self.fixedPriceIncludeManutention = fixedPriceIncludeManutention
////        self.operationalHours = operationalHours
////    }
////    init(priceBasedOnPurchaseAmount : Bool, priceBasedOnNBitems : Bool,fixedPriceIncludeManutention : Bool) {
////        self.priceBasedOnPurchaseAmount = priceBasedOnPurchaseAmount
////        self.priceBasedOnNBitems = priceBasedOnNBitems
////        self.fixedPriceIncludeManutention = fixedPriceIncludeManutention
////    }
////}

import Foundation

class Configs: Codable {
    let priceBasedOnWeight: Bool?
    let operationalHours: [OperationalHour]?
    let priceBasedOnNBitems, priceBasedOnPurchaseAmount, fixedPriceIncludeManutention: Bool?
    
    init(priceBasedOnWeight: Bool?, operationalHours: [OperationalHour]?, priceBasedOnNBitems: Bool?, priceBasedOnPurchaseAmount: Bool?, fixedPriceIncludeManutention: Bool?) {
        self.priceBasedOnWeight = priceBasedOnWeight
        self.operationalHours = operationalHours
        self.priceBasedOnNBitems = priceBasedOnNBitems
        self.priceBasedOnPurchaseAmount = priceBasedOnPurchaseAmount
        self.fixedPriceIncludeManutention = fixedPriceIncludeManutention
    }
}


extension Configs {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Configs.self, from: data)
        self.init(priceBasedOnWeight: me.priceBasedOnWeight, operationalHours: me.operationalHours, priceBasedOnNBitems: me.priceBasedOnNBitems, priceBasedOnPurchaseAmount: me.priceBasedOnPurchaseAmount, fixedPriceIncludeManutention: me.fixedPriceIncludeManutention)
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
        operationalHours: [OperationalHour]?? = nil,
        priceBasedOnNBitems: Bool?? = nil,
        priceBasedOnPurchaseAmount: Bool?? = nil,
        fixedPriceIncludeManutention: Bool?? = nil
        ) -> Configs {
        return Configs(
            priceBasedOnWeight: priceBasedOnWeight ?? self.priceBasedOnWeight,
            operationalHours: operationalHours ?? self.operationalHours,
            priceBasedOnNBitems: priceBasedOnNBitems ?? self.priceBasedOnNBitems,
            priceBasedOnPurchaseAmount: priceBasedOnPurchaseAmount ?? self.priceBasedOnPurchaseAmount,
            fixedPriceIncludeManutention: fixedPriceIncludeManutention ?? self.fixedPriceIncludeManutention
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
