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
import RealmSwift

class SocketIOManager: NSObject {
    static var token = UserDefaults.standard.string(forKey: "token") ?? SessionManager.currentSession.currentResponse!.authToken!.value!
    static let sharedInstance = SocketIOManager()
    static let manager = SocketManager(socketURL: URL(string: "https://rt.box2home.xyz")!, config: [.log(false), .connectParams(["token": token])])
    static let socket = manager.defaultSocket
   
  
    
    override init() {
       super.init()
        
        
        SocketIOManager.socket.on(clientEvent: .connect) { data, ack in
            
            print("SOCKET IS CONNECTED")
//            let myDictOfDict = SessionManager.currentSession.GetEmitDictionary()
            let myDictOfDict:[String:Any] = [
                "code" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.code!,
                "latitude" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.latitude.value!,
                "longitude" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.longitude.value!,
                "heading" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.heading.value!,
                "manutention" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.manutention.value!,
                "deviceInfo" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.deviceInfo!,
                "vehicule" : SessionManager.currentSession.getCurrentVehiculeDictionary()!
            ]
            
            print(myDictOfDict.description)
           
            SocketIOManager.socket.emitWithAck("driverConnect", myDictOfDict).timingOut(after: 0, callback: { (data) in
//                print(JSON(data))
            })
          
        }
        SocketIOManager.socket.on(clientEvent: .disconnect) { (data, ack) in
            print("SOCKET IS CONNECTED")
        }
        SocketIOManager.socket.on(clientEvent: .error) { (data, ack) in
            
        }
        
         SocketIOManager.socket.on("newCourse") { (data, ack) in
//            print("NewCourse INC")
        }
         SocketIOManager.socket.on("deposing") { (data, ack) in
            print("DEPOSING COURRSE INC")
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
            print("DELIVERING COURRSE INC")
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
            print("PICKUP COURRSE INC")
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
            print("ACCEPTED COURRSE INC")
            let str = data[0] as! String
            if let data = str.data(using: .utf8){
                let dict: [String: Any]!
                do {
                    dict = try JSONSerialization.jsonObject(with: data) as? [String : Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    let course = try Course(data: jsonData)
//                    print("\n\nCourse\n",course.description)
                    self.CourseAppend(tag: "accepted", course, completion: nil)
                }catch{
                    print(error)
                }
             }
        }
        
        SocketIOManager.socket.on("assigned") { (data, ack) in
            print("ASSIGNED COURRSE INC")
            let str = data[0] as! String
            if let data = str.data(using: .utf8){
//                print(JSON(data).description)
//                print(data)
                let dict: [String: Any]!
                do {
                    dict = try JSONSerialization.jsonObject(with: data) as? [String : Any]
//                    print("dict.description : ",dict.description)
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    let course = try Course(data: jsonData)
//                    print("course.description : ",course.description)
                    self.CourseAppend(tag: "assigned", course, completion: nil)
                  }catch{
                       print(error)
                    }
            }
        }
        
    }
    
    fileprivate func CourseAppend(tag: String,_ thisCourse: Course,completion: (() -> ())?) {
        RealmManager.sharedInstance.createOrUpdateCourse(thisCourse)
        completion?()
//        switch tag{
//        case "accepted":
//            SessionManager.currentSession.acceptedCourses.append(thisCourse)
//            completion?()
//        case "assigned":
//            SessionManager.currentSession.assignedCourses.append(thisCourse)
//            completion?()
//        default:
//            break
//        }
    }
   
  
    
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

extension SocketIOManager {
    static func myManager() -> SocketManager {
        return SocketManager(socketURL: URL(string: "https://rt.box2home.xyz")!, config: [.log(false), .connectParams(["token": SessionManager.currentSession.currentResponse!.authToken!.value!])])
    }
}
