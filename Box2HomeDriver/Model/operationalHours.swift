////
////  operationalHours.swift
////  Box2HomeDriver
////
////  Created by MacHD on 3/12/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
////struct operationalHours : Codable {
////    let dayOfWeek : dayOfWeek
////    let openTime : String
////    let closeTime : String
////    let deliveryWindow : Int
////
////    init(dayOfWeek : dayOfWeek, openTime : String, closeTime : String, deliveryWindow : Int) {
////        self.dayOfWeek = dayOfWeek
////        self.openTime = openTime
////        self.closeTime = closeTime
////        self.deliveryWindow = deliveryWindow
////    }
////
////}
//class OperationalHours: Decodable {
//    let dayOfWeek : DayOfWeek
//    let openTime : String
//    let closeTime : String
//    let deliveryWindow : Int
//
//
//    init(dayOfWeek : DayOfWeek, openTime : String, closeTime : String, deliveryWindow : Int) {
//        self.dayOfWeek = dayOfWeek
//        self.openTime = openTime
//        self.closeTime = closeTime
//        self.deliveryWindow = deliveryWindow
//    }
//    enum CodingKeys: String, CodingKey {
//        case dayOfWeek,openTime ,closeTime ,deliveryWindow
//    }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        dayOfWeek = try container.decode(DayOfWeek.self, forKey: .dayOfWeek)
//        openTime = try container.decode(String.self, forKey: .openTime)
//        closeTime = try container.decode(String.self, forKey: .closeTime)
//        deliveryWindow = try container.decode(Int.self, forKey: .deliveryWindow)
//    }
//}

import Foundation

class OperationalHour: Codable {
    let deliveryWindow: Int?
    let closeTime, openTime: String?
    let dayOfWeek: DayOfWeek?
    
    init(deliveryWindow: Int?, closeTime: String?, openTime: String?, dayOfWeek: DayOfWeek?) {
        self.deliveryWindow = deliveryWindow
        self.closeTime = closeTime
        self.openTime = openTime
        self.dayOfWeek = dayOfWeek
    }
}

extension OperationalHour {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(OperationalHour.self, from: data)
        self.init(deliveryWindow: me.deliveryWindow, closeTime: me.closeTime, openTime: me.openTime, dayOfWeek: me.dayOfWeek)
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
            deliveryWindow: deliveryWindow ?? self.deliveryWindow,
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
