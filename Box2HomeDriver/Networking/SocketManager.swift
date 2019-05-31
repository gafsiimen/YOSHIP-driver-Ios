//
//  SocketManager.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/8/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static var token = UserDefaults.standard.string(forKey: "token")!
    static let sharedInstance = SocketIOManager()
    static let manager = SocketManager(socketURL: URL(string: "https://rt.box2home.xyz")!, config: [.log(false), .connectParams(["token": token])])
    static let socket = manager.defaultSocket
    let viewModel = SocketViewModel(SocketRepository: SocketRepository())

  
    
    override init() {
       super.init()
        
        
        SocketIOManager.socket.on(clientEvent: .connect) { data, ack in
            
            print("SOCKET IS CONNECTED")
            NotificationCenter.default.post(name: NSNotification.Name("reachable"), object: nil)
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
            
//            print(myDictOfDict.description)
           
            SocketIOManager.socket.emitWithAck("driverConnect", myDictOfDict).timingOut(after: 0, callback: { (data) in
//                print(JSON(data))
            })
          
        }
        SocketIOManager.socket.on(clientEvent: .disconnect) { (data, ack) in
            print("SOCKET IS DISCONNECTED")
        }
        SocketIOManager.socket.on(clientEvent: .error) { (data, ack) in
            NotificationCenter.default.post(name: NSNotification.Name("unreachable"), object: nil)
        }
        
         SocketIOManager.socket.on("newCourse") { (data, ack) in
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
//                    print(dict.description)
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    let course = try Course(data: jsonData)
                    self.CourseAppend(tag: "assigned", course, completion: nil)
                  }catch{
                       print(error)
                    }
            }
        }
        
    }
    

    
    fileprivate func emitCourseAccept(_ thisCourse: Course) {
        let myDictOfDict:[String:Any] = [
            "codeCourse" : thisCourse.code!,
            "idChauffeur" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.id.value!,
            "codeCorner" : thisCourse.codeCorner!,
            "courseSource" : thisCourse.courseSource!,
            "vehicule" : SessionManager.currentSession.getCurrentVehiculeDictionary()!
        ]
        acceptCourse(dict: myDictOfDict)
    }
    
    fileprivate func emitCoursePickup(_ thisCourse: Course) {
        let myDictOfDict:[String:Any] = [
            "codeCourse" : thisCourse.code!,
            "idChauffeur" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.id.value!,
            "codeCorner" : thisCourse.codeCorner!,
            "courseSource" : thisCourse.courseSource!,
            "vehicule" : SessionManager.currentSession.getCurrentVehiculeDictionary()!
        ]
        pickUpCourse(dict: myDictOfDict)
    }
    
    fileprivate func emitCourseDelivering(_ thisCourse: Course) {
        let myDictOfDict:[String:Any] = [
            "codeCourse" : thisCourse.code!,
            "idChauffeur" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.id.value!,
            "codeCorner" : thisCourse.codeCorner!,
            "courseSource" : thisCourse.courseSource!,
            "vehicule" : SessionManager.currentSession.getCurrentVehiculeDictionary()!
        ]
        deliveringCourse(dict: myDictOfDict)
    }
    
    fileprivate func emitCourseDeposing(_ thisCourse: Course) {
        let myDictOfDict:[String:Any] = [
            "codeCourse" : thisCourse.code!,
            "idChauffeur" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.id.value!,
            "codeCorner" : thisCourse.codeCorner!,
            "courseSource" : thisCourse.courseSource!,
            "vehicule" : SessionManager.currentSession.getCurrentVehiculeDictionary()!
        ]
        deposingCourse(dict: myDictOfDict)
    }
    
    fileprivate func isLastCourse() -> Int {
        if (SessionManager.currentSession.acceptedCourses.count == 1) {
            return 1
        } else {
            return 0
        }
    }
    
    fileprivate func emitCourseEnd(_ thisCourse: Course) {
        let myDictOfDict:[String:Any] = [
            "codeCourse" : thisCourse.code!,
            "idChauffeur" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.id.value!,
            "km": 1,
            "duration" : 1,
            "codeCorner" : thisCourse.codeCorner!,
            "courseSource" : thisCourse.courseSource!,
            "isLastCourse" : isLastCourse()
        ]
        endCourse(dict: myDictOfDict)
    }
    
    fileprivate func CourseAppend(tag: String,_ thisCourse: Course,completion: (() -> ())?) {
        if let course = RealmManager.sharedInstance.CourseIfExists(primaryKey: thisCourse.code!) {
            
            switch course.status!.code! {
            case "ASSIGNED":
                print("hahaha  ASSIGNED course")
                
                switch thisCourse.status!.code! {
                case "ASSIGNED":
                    print("course: ASSIGNED , thisCourse: ASSIGNED")
//                    RealmManager.sharedInstance.createOrUpdateCourse(thisCourse)
                case "ACCEPTEE":
                    print("course: ASSIGNED , thisCourse: ACCEPTEE")
                case "ENLEVEMENT":
                    print("course: ASSIGNED , thisCourse: ENLEVEMENT")
                case "LIVRAISON":
                    print("course: ASSIGNED , thisCourse: LIVRAISON")
                case "DECHARGEMENT":
                    print("course: ASSIGNED , thisCourse: DECHARGEMENT")
                default:
                    print("\n status is not one of the four known values of status \n")
                    return
                    }
            case "ACCEPTEE":
                print("hahaha  ACCEPTEE course")
                
                switch thisCourse.status!.code! {
                case "ASSIGNED":
                    print("course: ACCEPTEE , thisCourse: ASSIGNED")
                    emitCourseAccept(thisCourse)
                case "ACCEPTEE":
                    print("course: ACCEPTEE , thisCourse: ACCEPTEE")
//                    RealmManager.sharedInstance.createOrUpdateCourse(thisCourse)
                case "ENLEVEMENT":
                    print("course: ACCEPTEE , thisCourse: ENLEVEMENT")
                case "LIVRAISON":
                    print("course: ACCEPTEE , thisCourse: LIVRAISON")
                case "DECHARGEMENT":
                    print("course: ACCEPTEE , thisCourse: DECHARGEMENT")
                default:
                    print("\n status is not one of the four known values of status \n")
                    return
                }
            case "ENLEVEMENT":
                print("hahaha  ENLEVEMENT course")
                
                switch thisCourse.status!.code! {
                case "ASSIGNED":
                    print("course: ENLEVEMENT , thisCourse: ASSIGNED")
                    emitCourseAccept(thisCourse)
                    emitCoursePickup(thisCourse)
                case "ACCEPTEE":
                    print("course: ENLEVEMENT , thisCourse: ACCEPTEE")
                    emitCoursePickup(thisCourse)
                case "ENLEVEMENT":
                    print("course: ENLEVEMENT , thisCourse: ENLEVEMENT")
//                    RealmManager.sharedInstance.createOrUpdateCourse(thisCourse)
                case "LIVRAISON":
                    print("course: ENLEVEMENT , thisCourse: LIVRAISON")
                case "DECHARGEMENT":
                    print("course: ENLEVEMENT , thisCourse: DECHARGEMENT")
                default:
                    print("\n status is not one of the four known values of status \n")
                    return
                }
            case "LIVRAISON":
                print("hahaha  LIVRAISON course")

                switch thisCourse.status!.code! {
                case "ASSIGNED":
                    print("course: LIVRAISON , thisCourse: ASSIGNED")
                    emitCourseAccept(thisCourse)
                    emitCoursePickup(thisCourse)
                    emitCourseDelivering(thisCourse)
                    viewModel.setPointEnlevement(codeCourse: course.code!, pointEnlevement: course.pointEnlevement!)
                    let imagesDepart = Array(course.colisImagesDataDepart).map{
                        UIImage(data: $0)!
                    }
                    viewModel.uploadPhotos(images: imagesDepart, codeCourse: course.code!, type: "depart")
                    viewModel.uploadSignature(image: UIImage(data: course.signatureDepartData!)! , codeCourse: course.code!, type: "depart")
                case "ACCEPTEE":
                    print("course: LIVRAISON , thisCourse: ACCEPTEE")
                    emitCoursePickup(thisCourse)
                    emitCourseDelivering(thisCourse)
                    viewModel.setPointEnlevement(codeCourse: course.code!, pointEnlevement: course.pointEnlevement!)
                    let imagesDepart = Array(course.colisImagesDataDepart).map{
                        UIImage(data: $0)!
                    }
                    viewModel.uploadPhotos(images: imagesDepart, codeCourse: course.code!, type: "depart")
                    viewModel.uploadSignature(image: UIImage(data: course.signatureDepartData!)! , codeCourse: course.code!, type: "depart")
                case "ENLEVEMENT":
                    print("course: LIVRAISON , thisCourse: ENLEVEMENT")
                    emitCourseDelivering(thisCourse)
                    viewModel.setPointEnlevement(codeCourse: course.code!, pointEnlevement: course.pointEnlevement!)
                    let imagesDepart = Array(course.colisImagesDataDepart).map{
                        UIImage(data: $0)!
                    }
                    viewModel.uploadPhotos(images: imagesDepart, codeCourse: course.code!, type: "depart")
                    viewModel.uploadSignature(image: UIImage(data: course.signatureDepartData!)! , codeCourse: course.code!, type: "depart")
                case "LIVRAISON":
                    print("course: LIVRAISON , thisCourse: LIVRAISON")
//                    RealmManager.sharedInstance.createOrUpdateCourse(thisCourse)
                case "DECHARGEMENT":
                    print("course: LIVRAISON , thisCourse: DECHARGEMENT")
                default:
                    print("\n status is not one of the four known values of status \n")
                    return
                }
            case "DECHARGEMENT":
                print("hahaha  DECHARGEMENT course")

                switch thisCourse.status!.code! {
                case "ASSIGNED":
                    print("course: DECHARGEMENT , thisCourse: ASSIGNED")
                    emitCourseAccept(thisCourse)
                    emitCoursePickup(thisCourse)
                    emitCourseDelivering(thisCourse)
                    viewModel.setPointEnlevement(codeCourse: course.code!, pointEnlevement: course.pointEnlevement!)
                    let imagesDepart = Array(course.colisImagesDataDepart).map{
                        UIImage(data: $0)!
                    }
                    viewModel.uploadPhotos(images: imagesDepart, codeCourse: course.code!, type: "depart")
                    viewModel.uploadSignature(image: UIImage(data: course.signatureDepartData!)! , codeCourse: course.code!, type: "depart")
                    emitCourseDeposing(thisCourse)
                case "ACCEPTEE":
                    print("course: DECHARGEMENT , thisCourse: ACCEPTEE")
                    emitCoursePickup(thisCourse)
                    emitCourseDelivering(thisCourse)
                    viewModel.setPointEnlevement(codeCourse: course.code!, pointEnlevement: course.pointEnlevement!)
                    let imagesDepart = Array(course.colisImagesDataDepart).map{
                        UIImage(data: $0)!
                    }
                    viewModel.uploadPhotos(images: imagesDepart, codeCourse: course.code!, type: "depart")
                    viewModel.uploadSignature(image: UIImage(data: course.signatureDepartData!)! , codeCourse: course.code!, type: "depart")
                    emitCourseDeposing(thisCourse)
                case "ENLEVEMENT":
                    print("course: DECHARGEMENT , thisCourse: ENLEVEMENT")
                    emitCourseDelivering(thisCourse)
                    viewModel.setPointEnlevement(codeCourse: course.code!, pointEnlevement: course.pointEnlevement!)
                    let imagesDepart = Array(course.colisImagesDataDepart).map{
                        UIImage(data: $0)!
                    }
                    viewModel.uploadPhotos(images: imagesDepart, codeCourse: course.code!, type: "depart")
                    viewModel.uploadSignature(image: UIImage(data: course.signatureDepartData!)! , codeCourse: course.code!, type: "depart")
                    emitCourseDeposing(thisCourse)
                case "LIVRAISON":
                    print("course: DECHARGEMENT , thisCourse: LIVRAISON")
                    emitCourseDeposing(thisCourse)
                case "DECHARGEMENT":
                    print("course: DECHARGEMENT , thisCourse: DECHARGEMENT")
//                    RealmManager.sharedInstance.createOrUpdateCourse(thisCourse)
                default:
                    print("\n thisCourse's status is not one of the four known values of status \n")
                    return
                }
            case "END":
                print("hahaha  END course")
                
                switch thisCourse.status!.code! {
                case "ASSIGNED":
                    print("course: END , thisCourse: ASSIGNED")
                    emitCourseAccept(thisCourse)
                    emitCoursePickup(thisCourse)
                    emitCourseDelivering(thisCourse)
                    viewModel.setPointEnlevement(codeCourse: course.code!, pointEnlevement: course.pointEnlevement!)
                    let imagesDepart = Array(course.colisImagesDataDepart).map{
                        UIImage(data: $0)!
                    }
                    let imagesArrivee = Array(course.colisImagesDataArrivee).map{
                        UIImage(data: $0)!
                    }
                    viewModel.uploadPhotos(images: imagesDepart, codeCourse: course.code!, type: "depart")
                    viewModel.uploadPhotos(images: imagesArrivee, codeCourse: course.code!, type: "arrivee")
                    viewModel.uploadSignature(image: UIImage(data: course.signatureDepartData!)! , codeCourse: course.code!, type: "depart")
                    emitCourseDeposing(thisCourse)
                    viewModel.uploadSignature(image: UIImage(data: course.signatureArriveeData!)! , codeCourse: course.code!, type: "arrivee")
                    emitCourseEnd(thisCourse)
                case "ACCEPTEE":
                    print("course: END , thisCourse: ACCEPTEE")
                    emitCoursePickup(thisCourse)
                    emitCourseDelivering(thisCourse)
                    viewModel.setPointEnlevement(codeCourse: course.code!, pointEnlevement: course.pointEnlevement!)
                    let imagesDepart = Array(course.colisImagesDataDepart).map{
                        UIImage(data: $0)!
                    }
                    let imagesArrivee = Array(course.colisImagesDataArrivee).map{
                        UIImage(data: $0)!
                    }
                    viewModel.uploadPhotos(images: imagesDepart, codeCourse: course.code!, type: "depart")
                    viewModel.uploadPhotos(images: imagesArrivee, codeCourse: course.code!, type: "arrivee")
                    viewModel.uploadSignature(image: UIImage(data: course.signatureDepartData!)! , codeCourse: course.code!, type: "depart")
                    emitCourseDeposing(thisCourse)
                    viewModel.uploadSignature(image: UIImage(data: course.signatureArriveeData!)! , codeCourse: course.code!, type: "arrivee")
                    emitCourseEnd(thisCourse)
                case "ENLEVEMENT":
                    print("course: END , thisCourse: ENLEVEMENT")
                    emitCourseDelivering(thisCourse)
                    viewModel.setPointEnlevement(codeCourse: course.code!, pointEnlevement: course.pointEnlevement!)
                    let imagesDepart = Array(course.colisImagesDataDepart).map{
                        UIImage(data: $0)!
                    }
                    let imagesArrivee = Array(course.colisImagesDataArrivee).map{
                        UIImage(data: $0)!
                    }
                    viewModel.uploadPhotos(images: imagesDepart, codeCourse: course.code!, type: "depart")
                    viewModel.uploadPhotos(images: imagesArrivee, codeCourse: course.code!, type: "arrivee")
                    viewModel.uploadSignature(image: UIImage(data: course.signatureDepartData!)! , codeCourse: course.code!, type: "depart")
                    emitCourseDeposing(thisCourse)
                    viewModel.uploadSignature(image: UIImage(data: course.signatureArriveeData!)! , codeCourse: course.code!, type: "arrivee")
                    emitCourseEnd(thisCourse)
                case "LIVRAISON":
                    print("course: END , thisCourse: LIVRAISON")
                    let imagesArrivee = Array(course.colisImagesDataArrivee).map{
                        UIImage(data: $0)!
                    }
                    viewModel.uploadPhotos(images: imagesArrivee, codeCourse: course.code!, type: "arrivee")
                    emitCourseDeposing(thisCourse)
                    viewModel.uploadSignature(image: UIImage(data: course.signatureArriveeData!)! , codeCourse: course.code!, type: "arrivee")
                    emitCourseEnd(thisCourse)
                case "DECHARGEMENT":
                    print("course: END , thisCourse: DECHARGEMENT")
                    var imagesArrivee : [Data] = []
                    imagesArrivee.append(contentsOf: course.colisImagesDataArrivee)
                    viewModel.uploadPhotos(images: imagesArrivee.map{ UIImage(data: $0)! }, codeCourse: course.code!, type: "arrivee")
                    viewModel.uploadSignature(image: UIImage(data: course.signatureArriveeData!)! , codeCourse: course.code!, type: "arrivee")
                    emitCourseEnd(thisCourse)

                default:
                    print("\n thisCourse's status is not one of the four known values of status \n")
                    return
                }
            default:
                print("\n course's status is not one of the four( + 'END') known values of status \n")
                return
              }
            }else{
            print("hahaha new course")
            RealmManager.sharedInstance.createOrUpdateCourse(thisCourse)
        }
        completion?()
    }
   
  
    
    //--------------------------------------------------------
    func acceptCourse(dict: [String:Any]) {
        SocketIOManager.socket.emitWithAck("courseAccepted", dict).timingOut(after: 0, callback: { (data) in
//            print(data.description)
        })
    }
    //--------------------------------------------------------
    func pickUpCourse(dict: [String:Any]) {
        SocketIOManager.socket.emitWithAck("pickUp", dict).timingOut(after: 0, callback: { (data) in
//                        print(data.description)
        })
    }
    //--------------------------------------------------------
    func deliveringCourse(dict: [String:Any]) {
        SocketIOManager.socket.emitWithAck("delivering", dict).timingOut(after: 0, callback: { (data) in
//                        print(data.description)
        })
    }
    //--------------------------------------------------------
    func deposingCourse(dict: [String:Any]) {
        SocketIOManager.socket.emitWithAck("deposing", dict).timingOut(after: 0, callback: { (data) in
//                        print(data.description)
        })
    }
    //--------------------------------------------------------
    func endCourse(dict: [String:Any]) {
        SocketIOManager.socket.emitWithAck("courseEnd", dict).timingOut(after: 0, callback: { (data) in
//                        print(data.description)
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
