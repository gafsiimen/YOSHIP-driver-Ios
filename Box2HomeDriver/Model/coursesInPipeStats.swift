////
////  coursesInPipeStats.swift
////  Box2HomeDriver
////
////  Created by MacHD on 3/1/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class CoursesInPipeStats: Decodable {
//    let assigned, inprogress: Int
//
//    enum CodingKeys: String, CodingKey {
//        case assigned = "ASSIGNED"
//        case inprogress = "INPROGRESS"
//    }
//
//    init(assigned: Int, inprogress: Int) {
//        self.assigned = assigned
//        self.inprogress = inprogress
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        assigned = try container.decode(Int.self, forKey: .assigned)
//        inprogress = try container.decode(Int.self, forKey: .inprogress)
//    }
//}
////struct coursesInPipeStats : Codable {
////    let INPROGRESS : Int
////    let ASSIGNED : Int
////    init(INPROGRESS:Int,ASSIGNED:Int){
////        self.INPROGRESS = INPROGRESS
////        self.ASSIGNED = ASSIGNED
////    }
////}

import Foundation


class CoursesInPipeStats: Codable {
    let assigned, inprogress: Int?
    
    enum CodingKeys: String, CodingKey {
        case assigned = "ASSIGNED"
        case inprogress = "INPROGRESS"
    }
    
    init(assigned: Int?, inprogress: Int?) {
        self.assigned = assigned
        self.inprogress = inprogress
    }
}


extension CoursesInPipeStats {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CoursesInPipeStats.self, from: data)
        self.init(assigned: me.assigned, inprogress: me.inprogress)
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
        assigned: Int?? = nil,
        inprogress: Int?? = nil
        ) -> CoursesInPipeStats {
        return CoursesInPipeStats(
            assigned: assigned ?? self.assigned,
            inprogress: inprogress ?? self.inprogress
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

