//
//  SessionManager.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/6/19.
//  Copyright © 2019 MacHD. All rights reserved.
//
import Foundation
import RealmSwift
import Realm
class SessionManager {
    static let currentSession = SessionManager()
    var sessionState = false {
        didSet{
            UserDefaults.standard.set(self.sessionState, forKey: "sessionState")
        }
    }
    var phone : String? {
        didSet{
            UserDefaults.standard.set(self.phone, forKey: "phone")
        }
    }
    
    var database : RealmManager?
    var notificationTokenCourses : NotificationToken? = NotificationToken()
    var notificationTokenResponse : NotificationToken? = NotificationToken()
    
    var acceptedCourses : [Course] = []
    var assignedCourses : [Course] = []

    var allCourses : [Course] = [] {
        didSet {
            SessionManager.currentSession.acceptedCourses = SessionManager.currentSession.allCourses.filter{$0.status!.code! != "ASSIGNED" && $0.status!.code! != "END"}
            SessionManager.currentSession.assignedCourses = SessionManager.currentSession.allCourses.filter{$0.status!.code! == "ASSIGNED"}
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)

        }
    }
    
    init() {
        database = RealmManager.sharedInstance
        let currentRealmResponse = database?.fetchResponse()
        let currentRealmCourses = database?.fetchCourses()
        //-----------------------------------------------------------------------------------------------------------------
                notificationTokenResponse = currentRealmResponse?.observe({ [weak self] (changes: RealmCollectionChange) in
                    switch(changes){
                    case .initial:
                        guard let response = currentRealmResponse?.first
                            else {
                                print("REALM RESPONSE IS EMPTY")
                                return
                        }
                        SessionManager.currentSession.currentResponse = response
                        SessionManager.currentSession.phone = response.authToken?.chauffeur?.phone
//                        print("INITIAL REALM RESPONSE : ",SessionManager.currentSession.currentResponse!.description)
        
                        break
                    case .update(_,let deletions,let insertions,let modifications):
                        guard let response = currentRealmResponse?.first
                                else {return}
                        insertions.forEach({ (index) in
                            SessionManager.currentSession.currentResponse = response
                            SessionManager.currentSession.phone = response.authToken?.chauffeur?.phone
//                            print("NEW REALM RESPONSE : ",SessionManager.currentSession.currentResponse!.description)
                        })
                        
        
                        break
                    case .error(let error):
                        print(error)
                        break
                    }
                })
        //-----------------------------------------------------------------------------------------------------------------
                notificationTokenCourses = currentRealmCourses?.observe({ [weak self](changes: RealmCollectionChange) in
                    switch(changes){
                    case .initial:
                        guard let results = currentRealmCourses
                            else {
                                print("REALM COURSES IS EMPTY")
                                return
                        }
                         results.forEach({ (course) in
                            let course = course
                            SessionManager.currentSession.allCourses.append(course)
        
                        })
                        break
                    case .update(_,let deletions,let insertions,let modifications):
                        guard let results = currentRealmCourses
                            else {
                                print("REALM COURSES IS EMPTY")
                                return
                        }
                        insertions.forEach({ (index) in
                           SessionManager.currentSession.allCourses.append(results[index])
//                            print(results[index].code!,"IS CREATED")
                        })
                        modifications.forEach({ (index) in
                            SessionManager.currentSession.allCourses = SessionManager.currentSession.allCourses.filter{$0.code! != results[index].code! }
                            SessionManager.currentSession.allCourses.append(results[index])
                      
                            
//                            print(results[index].code!," IS UPDATED")

                        })
                        
                        deletions.forEach({ (index) in
                         
                        })
        
                       

                        break
                    case .error(let error):
                        print(error)
                        break
                    }
                })
        
    }
    deinit {
        notificationTokenCourses?.invalidate()
        notificationTokenResponse?.invalidate()
        
    }
    
    
    
    
    var currentVehicule : Vehicule? = Vehicule(denomination: "Trafic", haillon: false, immatriculation: "122 TN 444", id: 4, status: 1, vehiculeCategory: VehiculeCategory(type: "S", volumeMax: 9, code: "S", id: 1))
    
    var currentRealmResponse: Response?
    //    var currentRealmAccepted : [Course]?
    //    var currentRealmAssigned : [Course]?
    
    var currentResponse : Response?
    var reconnectResponse : Response?

    //    func GetEmitDictionary() -> [String: Any] {
    //        let myDictOfDict:[String:Any] = [
    //            "code" : currentResponse!.authToken!.chauffeur!.code!,
    //            "latitude" : currentResponse!.authToken!.chauffeur!.latitude,
    //            "longitude" : currentResponse!.authToken!.chauffeur!.longitude,
    //            "heading" : currentResponse!.authToken!.chauffeur!.heading,
    //            "manutention" : currentResponse!.authToken!.chauffeur!.manutention,
    //            "deviceInfo" : currentResponse!.authToken!.chauffeur!.deviceInfo!,
    //            "vehicule" : getCurrentVehiculeDictionary()!
    //        ]
    //        return myDictOfDict
    //    }
    func updateCurrentVehicule(newVehicule: Vehicule) {
        self.currentVehicule = newVehicule
    }
    func getCurrentVehiculeDictionary() -> [String:Any]? {
        do {
            let data = try currentVehicule!.jsonData()
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    
    func signIn(response: Response,completion: (() -> ())?) {
        self.sessionState = true
        self.currentResponse = response
        
//        print("SIGNIN RESPONSE TOKEN : ",response.authToken!.value!)
        UserDefaults.standard.set(response.authToken!.value!, forKey: "token")
//        print("USER DEFAULTS TOKEN : ",UserDefaults.standard.string(forKey: "token")!)
        
//        print("SIGNIN RESPONSE : ",response.description)
        RealmManager.sharedInstance.persistResponse(response)
//        print("PERSISTED SIGNIN RESPONSE : ",RealmManager.sharedInstance.fetchResponse())

        completion?()
    }
    func Reconnect(response: Response,completion: (() -> ())?) {
        self.reconnectResponse = response
        UserDefaults.standard.set(response.authToken!.value!, forKey: "token")
        completion?()
    }
    func signOut() {
        SocketIOManager.sharedInstance.closeConnection()
        RealmManager.sharedInstance.deleteResponse()
        self.sessionState = false
        //       self.currentResponse = nil
        //       self.currentVehicule = nil
    }
    
}
extension Array where Element: Equatable {
    func all(where predicate: (Element) -> Bool) -> [Element]  {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}
