//
//  SessionManager.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/6/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

class SessionManager {
    
    static let currentSession = SessionManager()
    
    var message:String?
    var authToken:String?
    var code:String?
    var coursesInPipeStats:coursesInPipeStats?
    var chauffeur: chauffeur?
    
    func signIn(message:String,authToken:String,code:String,coursesInPipeStats:coursesInPipeStats,chauffeur:chauffeur){
        self.message = message
        self.code = code
        self.authToken = authToken
        self.coursesInPipeStats = coursesInPipeStats
        self.chauffeur = chauffeur
    }
    func signOut() {
        self.message = ""
        self.code = ""
        self.authToken = ""
        self.coursesInPipeStats = nil
        self.chauffeur = nil
    }
}
