//
//  SessionManager.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/6/19.
//  Copyright © 2019 MacHD. All rights reserved.
//
import Foundation

class SessionManager {
    
    static let currentSession = SessionManager()
    
    var acceptedCourses : [Course] = []
    var assignedCourses : [Course] = []
   
    
    var currentVehicule : Vehicule? = Vehicule(denomination: "Trafic", haillon: false, immatriculation: "122 TN 444", id: 4, status: 1, vehiculeCategory: VehiculeCategory(type: "S", volumeMax: 9, code: "S", id: 1))
    
    
    var currentResponse : Response?
    
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
        self.currentResponse = response
        completion?()
    }
    
    func signOut() {
       SocketIOManager.sharedInstance.closeConnection()
       self.currentResponse = nil
       self.currentVehicule = nil
    }
   
}
