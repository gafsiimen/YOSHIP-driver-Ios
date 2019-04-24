////
////  commande.swift
////  Box2HomeDriver
////
////  Created by MacHD on 2/26/19.
////  Copyright © 2019 MacHD. All rights reserved.
////
//
//import Foundation
//class Commande: Decodable {
//    let canalVente : CanalVente
//    let client : Client
//    let courses : [Course]
//    let promotion : String
//    let commandeExtra : String
//    let montantGlobalHT : Double
//    let codeTva : Int
//    let montantGlobalTtc : Int
//    let etatPaiement : String
//    let collaborateur : Collaborateur
//
//
//    enum CodingKeys: String, CodingKey {
//        case canalVente, client, courses
//        case montantGlobalHT = "montantGlobalHt"
//        case collaborateur, montantGlobalTtc, codeTva, promotion, etatPaiement, commandeExtra
//    }
//
//    init(canalVente : CanalVente, client : Client, courses : [Course], promotion : String, commandeExtra : String, montantGlobalHT : Double, codeTva : Int, montantGlobalTtc : Int, etatPaiement : String, collaborateur : Collaborateur) {
//        self.canalVente = canalVente
//        self.client = client
//        self.courses = courses
//        self.montantGlobalHT = montantGlobalHT
//        self.collaborateur = collaborateur
//        self.montantGlobalTtc = montantGlobalTtc
//        self.codeTva = codeTva
//        self.promotion = promotion
//        self.etatPaiement = etatPaiement
//        self.commandeExtra = commandeExtra
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        canalVente = try container.decode(CanalVente.self, forKey: .canalVente)
//        client = try container.decode(Client.self, forKey: .client)
//        courses = try container.decode([Course].self, forKey: .courses)
//        montantGlobalHT = try container.decode(Double.self, forKey: .montantGlobalHT)
//        collaborateur = try container.decode(Collaborateur.self, forKey: .collaborateur)
//        montantGlobalTtc = try container.decode(Int.self, forKey: .montantGlobalTtc)
//        codeTva = try container.decode(Int.self, forKey: .codeTva)
//        promotion = try container.decode(String.self, forKey: .promotion)
//        etatPaiement = try container.decode(String.self, forKey: .etatPaiement)
//        commandeExtra = try container.decode(String.self, forKey: .commandeExtra)
//
//
//    }
//}
////struct commande : Codable  {
////
////    let canalVente : canalVente
////    let client : client
////    let courses : [Course]
////    let promotion : String
////    let commandeExtra : String
////    let montantGlobalHt : Double
////    let codeTva : Int
////    let montantGlobalTtc : Int
////    let etatPaiement : String
////    let collaborateur : collaborateur
////}

import Foundation

class Commande: Codable {
    let canalVente: CanalVente?
    let client: Client?
    let montantGlobalHT: Double?
    let codeTva: Int?
    let collaborateur: Collaborateur?
    let montantGlobalTtc: Double?
    let promotion, etatPaiement, commandeExtra: String?
    
    enum CodingKeys: String, CodingKey {
        case canalVente, client
        case montantGlobalHT = "montantGlobalHt"
        case collaborateur, montantGlobalTtc, codeTva, promotion, etatPaiement, commandeExtra
    }
    
    init(canalVente: CanalVente?, client: Client?, montantGlobalHT: Double?, collaborateur: Collaborateur?, montantGlobalTtc: Double?, codeTva: Int?, promotion: String?, etatPaiement: String?, commandeExtra: String?) {
        self.canalVente = canalVente
        self.client = client
        self.montantGlobalHT = montantGlobalHT
        self.collaborateur = collaborateur
        self.montantGlobalTtc = montantGlobalTtc
        self.codeTva = codeTva
        self.promotion = promotion
        self.etatPaiement = etatPaiement
        self.commandeExtra = commandeExtra
    }
}
extension Commande {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Commande.self, from: data)
        self.init(canalVente: me.canalVente, client: me.client, montantGlobalHT: me.montantGlobalHT, collaborateur: me.collaborateur, montantGlobalTtc: me.montantGlobalTtc, codeTva: me.codeTva, promotion: me.promotion, etatPaiement: me.etatPaiement, commandeExtra: me.commandeExtra)
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
        canalVente: CanalVente?? = nil,
        client: Client?? = nil,
        montantGlobalHT: Double?? = nil,
        collaborateur: Collaborateur?? = nil,
        montantGlobalTtc: Double?? = nil,
        codeTva: Int?? = nil,
        promotion: String?? = nil,
        etatPaiement: String?? = nil,
        commandeExtra: String?? = nil
        ) -> Commande {
        return Commande(
            canalVente: canalVente ?? self.canalVente,
            client: client ?? self.client,
            montantGlobalHT: montantGlobalHT ?? self.montantGlobalHT,
            collaborateur: collaborateur ?? self.collaborateur,
            montantGlobalTtc: montantGlobalTtc ?? self.montantGlobalTtc,
            codeTva: codeTva ?? self.codeTva,
            promotion: promotion ?? self.promotion,
            etatPaiement: etatPaiement ?? self.etatPaiement,
            commandeExtra: commandeExtra ?? self.commandeExtra
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
