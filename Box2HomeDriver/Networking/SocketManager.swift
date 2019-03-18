//
//  SocketManager.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/8/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON
class SocketIOManager: NSObject {
//     var InitialAcceptedCourses : [Course] = []
     static let sharedInstance = SocketIOManager()
     static let manager = SocketManager(socketURL: URL(string: "https://rt.box2home.xyz")!, config: [.log(false), .connectParams(["token":SessionManager.currentSession.authToken!])])
//    RwsGzmdmMbGef2BW+IjvFR7MZlWLzedrOsQUxmfMvcAMj9lu7fQgiKO+OUZu/wnwsUw=
    static let socket = manager.defaultSocket
   
    override init() {
       super.init()
        
        let myDictOfDict:[String:Any] = [
            "code" : "CHF-0003",
            "latitude" : "35.825059600000003",
            "longitude" : "10.6327476",
            "heading" : "127.0",
            "manutention" : 0,
            "deviceInfo" : "xxxxxcxxx",
            "vehicule" : ["denomination":"Trafic",
                          "haillon": false,
//                          "image" : nil,
                          "immatriculation" : "122 TN 444",
                          "id" : 4,
                          "status" : 1,
                          "vehicule_category" :  ["type" : "S",
                                                  "volumeMax" : 9,
                                                  "code" : "S",
                                                  "id" : 1       ]
            ]
        ]
//        var myDict:NSDictionary = ["Data" : myDictOfDict]
        
        
     
    
       
//    print(JSON(myDictOfDict))
        
    
        
        SocketIOManager.socket.on(clientEvent: .connect) { data, ack in
            SocketIOManager.socket.emitWithAck("driverConnect", myDictOfDict).timingOut(after: 0, callback: { (data) in
                print(JSON(data))
            })
          
        }
        SocketIOManager.socket.on("accepted") { (data, ack) in
            let str = data[0] as! String
            if let data = str.data(using: .utf8){
                var dict:JSON!
                do {
                    dict = try JSON(data: data)
                } catch {
                    print("Error JSON: \(error)")
                }
//                print(dict.description)
                var courses : [Course] = []
                let thisCourse = Course(id: dict["id"].intValue,
                                        code: dict["code"].stringValue,
                                        courseSource: dict["courseSource"].stringValue,
                                        adresseDepart: adresse(id: dict["adresseDepart"]["id"].intValue,
                                                               label: dict["adresseDepart"]["id"].stringValue,
                                                               address: dict["adresseDepart"]["address"].stringValue,
                                                               latitude: dict["adresseDepart"]["latitude"].doubleValue,
                                                               longitude:dict["adresseDepart"]["longitude"].doubleValue,
                                                               postalCode: dict["adresseDepart"]["postalCode"].intValue),
                                        pointEnlevement: dict["pointEnlevement"].stringValue,
                                        vehiculeType: dict["vehiculeType"].stringValue,
                                        moyenPaiement: moyenPaiement(code: dict["moyenPaiement"]["code"].stringValue,
                                                                     label: dict["moyenPaiement"]["label"].stringValue),
                                        observation: dict["observation"].stringValue,
                                        observationArrivee: dict["observationArrivee"].stringValue,
                                        factures: dict["factures"].stringValue,
                                        adresseArrivee: adresse(id: dict["adresseArrivee"]["id"].intValue,
                                                                label: dict["adresseArrivee"]["id"].stringValue,
                                                                address: dict["adresseArrivee"]["address"].stringValue,
                                                                latitude: dict["adresseArrivee"]["latitude"].doubleValue,
                                                                longitude:dict["adresseArrivee"]["longitude"].doubleValue,
                                                                postalCode: dict["adresseArrivee"]["postalCode"].intValue),
                                        chauffeur: chauffeur(lastname: dict["chauffeur"]["lastname"].stringValue,
                                                             firstname: dict["chauffeur"]["firstname"].stringValue,
                                                             code: dict["chauffeur"]["code"].stringValue),
                                        vehicule: vehicule(id: dict["vehicule"]["id"].intValue,
                                                           status: dict["vehicule"]["status"].intValue,
                                                           vehicule_category: Vehicule_category(code: dict["vehicule"]["vehicule_category"]["code"].stringValue,
                                                                                                type: dict["vehicule"]["vehicule_category"]["type"].stringValue,
                                                                                                volumeMax: dict["vehicule"]["vehicule_category"]["volumeMax"].intValue),
                                                           haillon: dict["vehicule"]["haillon"].boolValue,
                                                           denomination: dict["vehicule"]["denomination"].stringValue,
                                                           immatriculation: dict["vehicule"]["immatriculation"].stringValue),
                                        lettreDeVoiture: lettreDeVoiture(id: dict["lettreDeVoiture"]["id"].intValue,
                                                                         code: dict["lettreDeVoiture"]["code"].stringValue,
                                                                         reference: dict["lettreDeVoiture"]["reference"].stringValue),
                                        contactArrivee: contact(firstname: dict["contactArrivee"]["firstname"].stringValue,
                                                                lastname: dict["contactArrivee"]["lastname"].stringValue,
                                                                phone: dict["contactArrivee"]["phone"].stringValue,
                                                                mail: dict["contactArrivee"]["mail"].stringValue),
                                        contactDepart: contact(firstname: dict["contactDepart"]["firstname"].stringValue,
                                                               lastname: dict["contactDepart"]["lastname"].stringValue,
                                                               phone: dict["contactDepart"]["phone"].stringValue,
                                                               mail: dict["contactDepart"]["mail"].stringValue),
                                        nombreColis: dict["nombreColis"].intValue,
                                        manutention: dict["manutention"].boolValue,
                                        manutentionDouble: dict["manutentionDouble"].boolValue,
                                        estimatedKM:dict["estimatedKM"].doubleValue ,
                                        status: status(color: dict["status"]["color"].stringValue,
                                                       code: dict["status"]["code"].stringValue,
                                                       label: dict["status"]["label"].stringValue),
                                        commande: commande( canalVente: canalVente(configs: configs(priceBasedOnPurchaseAmount: dict["commande"]["canalVente"]["configs"]["priceBasedOnPurchaseAmount"].boolValue,
                                                                                                    priceBasedOnNBitems: dict["commande"]["canalVente"]["configs"]["priceBasedOnNBitems"].boolValue,
                                                                                                    fixedPriceIncludeManutention: dict["commande"]["canalVente"]["configs"]["fixedPriceIncludeManutention"].boolValue,
                                                                                                    operationalHours: self.GetOperationalHours(json: dict["commande"]["canalVente"]["configs"]["operationalHours"])),
                                                                                   code: dict["commande"]["canalVente"]["code"].stringValue,
                                                                                   name: dict["commande"]["canalVente"]["name"].stringValue,
                                                                                   articleFamilies: self.GetArticleFamilies(json: dict["commande"]["canalVente"]["articleFamilies"])),
                                                            client: client(firstname: dict["commande"]["client"]["firstname"].stringValue,
                                                                           lastname: dict["commande"]["client"]["lastname"].stringValue,
                                                                           phone: dict["commande"]["client"]["phone"].stringValue,
                                                                           mail: dict["commande"]["client"]["mail"].stringValue,
                                                                           avatarURL: dict["commande"]["client"]["avatarURL"].stringValue,
                                                                           societe: societe(name: dict["commande"]["client"]["societe"]["name"].stringValue)),
                                                            courses: courses,
                                                            promotion: dict["commande"]["promotion"].stringValue,
                                                            commandeExtra: dict["commande"]["commandeExtra"].stringValue,
                                                            montantGlobalHt: dict["commande"]["montantGlobalHt"].doubleValue,
                                                            codeTva: dict["commande"]["codeTva"].intValue,
                                                            montantGlobalTtc: dict["commande"]["montantGlobalTtc"].intValue,
                                                            etatPaiement: dict["commande"]["etatPaiement"].stringValue,
                                                            collaborateur: collaborateur(lastname: dict["commande"]["collaborateur"]["lastname"].stringValue,
                                                                                         firstname: dict["commande"]["collaborateur"]["firstname"].stringValue)),
                                        dateDemarrage: dict["dateDemarrage"].stringValue,
                                        dateAcceptation: dict["dateAcceptation"].stringValue,
                                        dateEnlevement: dict["dateEnlevement"].stringValue,
                                        dateLivraison: dict["dateLivraison"].stringValue,
                                        dateAffirmationFin: dict["dateAffirmationFin"].stringValue,
                                        createdAt: dict["createdAt"].stringValue,
                                        montantHT: dict["montantHT"].stringValue,
                                        signaturesImages: self.GetStringArray(json: dict["signaturesImages"]),
                                        colisImages: self.GetStringArray(json: dict["colisImages"]),
                                        scannedDocs: self.GetStringArray(json: dict["scannedDocs"]),
                                        articles: self.GetStringArray(json: dict["scannedDocs"]),
                                        articleFamilies: self.GetArticleFamilies(json: dict["articleFamilies"]),
                                        isStatusChangedManually: dict["isStatusChangedManually"].boolValue,
                                        dateDemarrageMeta: dict["dateDemarrageMeta"].stringValue,
                                        codeCorner: dict["codeCorner"].stringValue)
                
                SessionManager.currentSession.acceptedCourses.append(thisCourse)
            }

        }
        
        
        SocketIOManager.socket.on("assigned") { (data, ack) in
            let str = data[0] as! String
            if let data = str.data(using: .utf8){
                var dict:JSON!
                do {
                    dict = try JSON(data: data)
                } catch {
                    print("Error JSON: \(error)")
                }
//                print(dict.description)
                var courses : [Course] = []
                let thisCourse = Course(id: dict["id"].intValue,
                                        code: dict["code"].stringValue,
                                        courseSource: dict["courseSource"].stringValue,
                                        adresseDepart: adresse(id: dict["adresseDepart"]["id"].intValue,
                                                               label: dict["adresseDepart"]["id"].stringValue,
                                                               address: dict["adresseDepart"]["address"].stringValue,
                                                               latitude: dict["adresseDepart"]["latitude"].doubleValue,
                                                               longitude:dict["adresseDepart"]["longitude"].doubleValue,
                                                               postalCode: dict["adresseDepart"]["postalCode"].intValue),
                                        pointEnlevement: dict["pointEnlevement"].stringValue,
                                        vehiculeType: dict["vehiculeType"].stringValue,
                                        moyenPaiement: moyenPaiement(code: dict["moyenPaiement"]["code"].stringValue,
                                                                     label: dict["moyenPaiement"]["label"].stringValue),
                                        observation: dict["observation"].stringValue,
                                        observationArrivee: dict["observationArrivee"].stringValue,
                                        factures: dict["factures"].stringValue,
                                        adresseArrivee: adresse(id: dict["adresseArrivee"]["id"].intValue,
                                                                label: dict["adresseArrivee"]["id"].stringValue,
                                                                address: dict["adresseArrivee"]["address"].stringValue,
                                                                latitude: dict["adresseArrivee"]["latitude"].doubleValue,
                                                                longitude:dict["adresseArrivee"]["longitude"].doubleValue,
                                                                postalCode: dict["adresseArrivee"]["postalCode"].intValue),
                                        chauffeur: chauffeur(lastname: dict["chauffeur"]["lastname"].stringValue,
                                                             firstname: dict["chauffeur"]["firstname"].stringValue,
                                                             code: dict["chauffeur"]["code"].stringValue),
                                        vehicule: vehicule(id: dict["vehicule"]["id"].intValue,
                                                           status: dict["vehicule"]["status"].intValue,
                                                           vehicule_category: Vehicule_category(code: dict["vehicule"]["vehicule_category"]["code"].stringValue,
                                                                                                type: dict["vehicule"]["vehicule_category"]["type"].stringValue,
                                                                                                volumeMax: dict["vehicule"]["vehicule_category"]["volumeMax"].intValue),
                                                           haillon: dict["vehicule"]["haillon"].boolValue,
                                                           denomination: dict["vehicule"]["denomination"].stringValue,
                                                           immatriculation: dict["vehicule"]["immatriculation"].stringValue),
                                        lettreDeVoiture: lettreDeVoiture(id: dict["lettreDeVoiture"]["id"].intValue,
                                                                         code: dict["lettreDeVoiture"]["code"].stringValue,
                                                                         reference: dict["lettreDeVoiture"]["reference"].stringValue),
                                        contactArrivee: contact(firstname: dict["contactArrivee"]["firstname"].stringValue,
                                                                lastname: dict["contactArrivee"]["lastname"].stringValue,
                                                                phone: dict["contactArrivee"]["phone"].stringValue,
                                                                mail: dict["contactArrivee"]["mail"].stringValue),
                                        contactDepart: contact(firstname: dict["contactDepart"]["firstname"].stringValue,
                                                               lastname: dict["contactDepart"]["lastname"].stringValue,
                                                               phone: dict["contactDepart"]["phone"].stringValue,
                                                               mail: dict["contactDepart"]["mail"].stringValue),
                                        nombreColis: dict["nombreColis"].intValue,
                                        manutention: dict["manutention"].boolValue,
                                        manutentionDouble: dict["manutentionDouble"].boolValue,
                                        estimatedKM:dict["estimatedKM"].doubleValue ,
                                        status: status(color: dict["status"]["color"].stringValue,
                                                       code: dict["status"]["code"].stringValue,
                                                       label: dict["status"]["label"].stringValue),
                                        commande: commande( canalVente: canalVente(configs: configs(priceBasedOnPurchaseAmount: dict["commande"]["canalVente"]["configs"]["priceBasedOnPurchaseAmount"].boolValue,
                                                                                                    priceBasedOnNBitems: dict["commande"]["canalVente"]["configs"]["priceBasedOnNBitems"].boolValue,
                                                                                                    fixedPriceIncludeManutention: dict["commande"]["canalVente"]["configs"]["fixedPriceIncludeManutention"].boolValue,
                                                                                                    operationalHours: self.GetOperationalHours(json: dict["commande"]["canalVente"]["configs"]["operationalHours"])),
                                                                                   code: dict["commande"]["canalVente"]["code"].stringValue,
                                                                                   name: dict["commande"]["canalVente"]["name"].stringValue,
                                                                                   articleFamilies: self.GetArticleFamilies(json: dict["commande"]["canalVente"]["articleFamilies"])),
                                                            client: client(firstname: dict["commande"]["client"]["firstname"].stringValue,
                                                                           lastname: dict["commande"]["client"]["lastname"].stringValue,
                                                                           phone: dict["commande"]["client"]["phone"].stringValue,
                                                                           mail: dict["commande"]["client"]["mail"].stringValue,
                                                                           avatarURL: dict["commande"]["client"]["avatarURL"].stringValue,
                                                                           societe: societe(name: dict["commande"]["client"]["societe"]["name"].stringValue)),
                                                            courses: courses,
                                                            promotion: dict["commande"]["promotion"].stringValue,
                                                            commandeExtra: dict["commande"]["commandeExtra"].stringValue,
                                                            montantGlobalHt: dict["commande"]["montantGlobalHt"].doubleValue,
                                                            codeTva: dict["commande"]["codeTva"].intValue,
                                                            montantGlobalTtc: dict["commande"]["montantGlobalTtc"].intValue,
                                                            etatPaiement: dict["commande"]["etatPaiement"].stringValue,
                                                            collaborateur: collaborateur(lastname: dict["commande"]["collaborateur"]["lastname"].stringValue,
                                                                                         firstname: dict["commande"]["collaborateur"]["firstname"].stringValue)),
                                        dateDemarrage: dict["dateDemarrage"].stringValue,
                                        dateAcceptation: dict["dateAcceptation"].stringValue,
                                        dateEnlevement: dict["dateEnlevement"].stringValue,
                                        dateLivraison: dict["dateLivraison"].stringValue,
                                        dateAffirmationFin: dict["dateAffirmationFin"].stringValue,
                                        createdAt: dict["createdAt"].stringValue,
                                        montantHT: dict["montantHT"].stringValue,
                                        signaturesImages: self.GetStringArray(json: dict["signaturesImages"]),
                                        colisImages: self.GetStringArray(json: dict["colisImages"]),
                                        scannedDocs: self.GetStringArray(json: dict["scannedDocs"]),
                                        articles: self.GetStringArray(json: dict["scannedDocs"]),
                                        articleFamilies: self.GetArticleFamilies(json: dict["articleFamilies"]),
                                        isStatusChangedManually: dict["isStatusChangedManually"].boolValue,
                                        dateDemarrageMeta: dict["dateDemarrageMeta"].stringValue,
                                        codeCorner: dict["codeCorner"].stringValue)
                
                SessionManager.currentSession.assignedCourses.append(thisCourse)
            }
        }
        
        
        
        
        
    }
   
    func GetStringArray(json: JSON) -> [String] {
        var StringArray : [String] = []
        let strArray = json.arrayValue
        for element in strArray {
            StringArray.append(
                element.stringValue
            )
        }
        return StringArray
    }
    func GetOperationalHours(json: JSON) -> [operationalHours] {
        var OperationalHours : [operationalHours] = []
        let oh = json.arrayValue
        for element in oh {
            OperationalHours.append(
                operationalHours(dayOfWeek: dayOfWeek(label: element["dayOfWeek"]["label"].stringValue,
                                                      code: element["dayOfWeek"]["code"].stringValue),
                                 openTime: element["openTime"].stringValue,
                                 closeTime: element["closeTime"].stringValue,
                                 deliveryWindow: element["deliveryWindow"].intValue)
            )
        }
        return OperationalHours
    }
    func GetArticleFamilies(json: JSON) -> [articleFamily] {
        var ArticleFamilies : [articleFamily] = []
        let af = json.arrayValue
        for element in af {
            ArticleFamilies.append(
                articleFamily(code: element["code"].stringValue,
                              label: element["label"].stringValue)
            )
        }
        return ArticleFamilies
    }
    //--------------------------------------------------------
//    var vehicules : [vehicule] = []
//    let veh = dict["chauffeur"]["vehicules"].arrayValue
//    for element in veh {
//    vehicules.append(
//    vehicule(id: element["id"].intValue,
//    status: element["status"].intValue,
//    vehicule_category: Vehicule_category(
//    code: element["vehicule_category"]["code"].stringValue,
//    type: element["vehicule_category"]["type"].stringValue,
//    volumeMax:element["vehicule_category"]["volumeMax"].intValue,
//    id: element["vehicule_category"]["id"].intValue),
//    haillon: element["haillon"].boolValue,
//    denomination: element["denomination"].stringValue,
//    immatriculation: element["immatriculation"].stringValue
//    ))
//    }
    //--------------------------------------------------------
    func establishConnection() {
        SocketIOManager.socket.connect()
    }
    
    func closeConnection() {
        SocketIOManager.socket.disconnect()
    }
    
   
}
