//
//  SessionManager.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/6/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

class SessionManager {
    
    static let currentSession = SessionManager()
    
    var acceptedCourses : [Course] = []
    var assignedCourses : [Course] = []
    
    var message:String?
    var authToken:String?
    var code:String?
    var coursesInPipeStats:coursesInPipeStats?
    var chauffeur: chauffeur?
    
    func signIn(message:String,authToken:String,code:String,coursesInPipeStats:coursesInPipeStats,chauffeur:chauffeur){
        SocketIOManager.sharedInstance.establishConnection()
        self.message = message
        self.code = code
        self.authToken = authToken
        self.coursesInPipeStats = coursesInPipeStats
        self.chauffeur = chauffeur
    }
    func signOut() {
        SocketIOManager.sharedInstance.closeConnection()
        self.message = ""
        self.code = ""
        self.authToken = ""
        self.coursesInPipeStats = nil
        self.chauffeur = nil
    }
    func GetImageIntType(s:String) -> Int {
        switch s {
        case "S":
            return 0
        case "M":
            return 1
        case "L":
            return 2
        default:
            return 3
        }
    }
}
