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

    func signIn(message:String,authToken:String,code:String,coursesInPipeStats:coursesInPipeStats,chauffeur:chauffeur,completion: () -> ()) {
        self.authToken = authToken
        self.message = message
        self.code = code
        self.coursesInPipeStats = coursesInPipeStats
        self.chauffeur = chauffeur
        completion()
    }
    func signOut() {
        SocketIOManager.sharedInstance.closeConnection()
        self.message = ""
        self.code = ""
        self.authToken = ""
        self.coursesInPipeStats = nil
        self.chauffeur = nil
    }
   
}
