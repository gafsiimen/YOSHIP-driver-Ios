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
import SwiftEventBus
class SocketIOManager: NSObject {
//     var InitialAcceptedCourses : [Course] = []
     static let sharedInstance = SocketIOManager()
     static let manager = SocketManager(socketURL: URL(string: "https://rt.box2home.xyz")!, config: [.log(false), .connectParams(["token":SessionManager.currentSession.currentResponse!.authToken!.value!])])
//    RwsGzmdmMbGef2BW+IjvFR7MZlWLzedrOsQUxmfMvcAMj9lu7fQgiKO+OUZu/wnwsUw=
    static let socket = manager.defaultSocket
   
  
    
    override init() {
       super.init()
        
        let myDictOfDict:[String:Any] = [
            "code" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.code!,
            "latitude" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.latitude!,
            "longitude" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.longitude!,
            "heading" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.heading!,
            "manutention" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.manutention!,
            "deviceInfo" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.deviceInfo!,
            "vehicule" : ["denomination":SessionManager.currentSession.currentVehicule!.denomination!,
                          "haillon": SessionManager.currentSession.currentVehicule!.haillon!,
                          "immatriculation" : SessionManager.currentSession.currentVehicule!.immatriculation!,
                          "id" : SessionManager.currentSession.currentVehicule!.id!,
                          "status" : SessionManager.currentSession.currentVehicule!.status!,
                          "vehicule_category" :  ["type" : SessionManager.currentSession.currentVehicule!.vehiculeCategory!.type!,
                                                  "volumeMax" : SessionManager.currentSession.currentVehicule!.vehiculeCategory!.volumeMax!,
                                                  "code" : SessionManager.currentSession.currentVehicule!.vehiculeCategory!.code!,
                                                  "id" : SessionManager.currentSession.currentVehicule!.vehiculeCategory!.id!       ]
            ]
        ]
        
        
        SocketIOManager.socket.on(clientEvent: .connect) { data, ack in
            SocketIOManager.socket.emitWithAck("driverConnect", myDictOfDict).timingOut(after: 0, callback: { (data) in
//                print(JSON(data))
            })
          
        }
        SocketIOManager.socket.on(clientEvent: .disconnect) { (data, ack) in
        
        }
        SocketIOManager.socket.on(clientEvent: .error) { (data, ack) in
            
        }
        
         SocketIOManager.socket.on("newCourse") { (data, ack) in
//            print("NewCourse INC")
        }
        SocketIOManager.socket.on("deposing") { (data, ack) in
            let str = data[0] as! String
            if let data = str.data(using: .utf8){
                let dict: [String: Any]!
                do {
                    dict = try JSONSerialization.jsonObject(with: data) as? [String : Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    let course = try Course(data: jsonData)
                    self.CourseAppend(tag: "accepted", course, completion: nil)
                }catch{
                    print(error)
                }
            }
        }
        SocketIOManager.socket.on("delivering") { (data, ack) in
            let str = data[0] as! String
            if let data = str.data(using: .utf8){
                let dict: [String: Any]!
                do {
                    dict = try JSONSerialization.jsonObject(with: data) as? [String : Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    let course = try Course(data: jsonData)
                    self.CourseAppend(tag: "accepted", course, completion: nil)
                }catch{
                    print(error)
                }
            }
        }
        SocketIOManager.socket.on("pickUp") { (data, ack) in
            let str = data[0] as! String
            if let data = str.data(using: .utf8){
                let dict: [String: Any]!
                do {
                    dict = try JSONSerialization.jsonObject(with: data) as? [String : Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    let course = try Course(data: jsonData)
                    self.CourseAppend(tag: "accepted", course, completion: nil)
                }catch{
                    print(error)
                }
            }
        }
        SocketIOManager.socket.on("accepted") { (data, ack) in
            let str = data[0] as! String
            if let data = str.data(using: .utf8){
                let dict: [String: Any]!
                do {
                    dict = try JSONSerialization.jsonObject(with: data) as? [String : Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    let course = try Course(data: jsonData)
                    self.CourseAppend(tag: "accepted", course, completion: nil)
                }catch{
                    print(error)
                }
             }
        }
        
        SocketIOManager.socket.on("assigned") { (data, ack) in
            let str = data[0] as! String
            if let data = str.data(using: .utf8){
                let dict: [String: Any]!
                do {
                    dict = try JSONSerialization.jsonObject(with: data) as? [String : Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    let course = try Course(data: jsonData)
                    self.CourseAppend(tag: "assigned", course, completion: {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: "assigned")
                       })
                  }catch{
                       print(error)
                    }
            }
        }
        
    }
    
    fileprivate func CourseAppend(tag: String,_ thisCourse: Course,completion: (() -> ())?) {
        switch tag{
        case "accepted":
            SessionManager.currentSession.acceptedCourses.append(thisCourse)
            completion?()
        case "assigned":
            SessionManager.currentSession.assignedCourses.append(thisCourse)
            completion?()
        default:
            break
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
    func GetOperationalHours(json: JSON) -> [OperationalHour] {
        var operationalHours : [OperationalHour] = []
        let oh = json.arrayValue
        for element in oh {
            operationalHours.append(
                OperationalHour( deliveryWindow: element["deliveryWindow"].intValue,
                                 closeTime: element["closeTime"].stringValue,
                                 openTime: element["openTime"].stringValue,
                                 dayOfWeek: DayOfWeek(label: element["dayOfWeek"]["label"].stringValue,
                                                      code: element["dayOfWeek"]["code"].stringValue))
            )
        }
        return operationalHours
    }
    func GetSignatureImages(json: JSON) -> [SignatureImage] {
        var signatureImages : [SignatureImage] = []
        let si = json.arrayValue
        for element in si {
            signatureImages.append(
              SignatureImage(type: element["type"].stringValue,
                             url: element["url"].stringValue)
            )
        }
        return signatureImages
    }
    func GetArticleFamilies(json: JSON) -> [ArticleFamily] {
        var ArticleFamilies : [ArticleFamily] = []
        let af = json.arrayValue
        for element in af {
            ArticleFamilies.append(
                ArticleFamily(code: element["code"].stringValue,
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
    func acceptCourse(dict: [String:Any]) {
        SocketIOManager.socket.emitWithAck("courseAccepted", dict).timingOut(after: 0, callback: { (data) in
//            print(JSON(data[0])["course"].description.description)
        })
    }
    //--------------------------------------------------------
    func pickUpCourse(dict: [String:Any]) {
        SocketIOManager.socket.emitWithAck("pickUp", dict).timingOut(after: 0, callback: { (data) in
            //            print(JSON(data[0])["course"].description.description)
        })
    }
    //--------------------------------------------------------
    func deliveringCourse(dict: [String:Any]) {
        SocketIOManager.socket.emitWithAck("delivering", dict).timingOut(after: 0, callback: { (data) in
            //            print(JSON(data[0])["course"].description.description)
        })
    }
    //--------------------------------------------------------
    func deposingCourse(dict: [String:Any]) {
        SocketIOManager.socket.emitWithAck("deposing", dict).timingOut(after: 0, callback: { (data) in
            //            print(JSON(data[0])["course"].description.description)
        })
    }
    //--------------------------------------------------------
    func endCourse(dict: [String:Any]) {
        SocketIOManager.socket.emitWithAck("courseEnd", dict).timingOut(after: 0, callback: { (data) in
            //            print(JSON(data[0])["course"].description.description)
        })
    }
    //--------------------------------------------------------
    func establishConnection() {
        SocketIOManager.socket.connect()
    }
    
    func closeConnection() {
        SocketIOManager.socket.disconnect()
    }
    
   
}
