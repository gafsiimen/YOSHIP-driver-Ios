//
//  LoginModelView.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/1/19.
//  Copyright © 2019 MacHD. All rights reserved.
//


import SwiftyJSON
import UIKit
class LoginViewModel {
    
    var vehicules : [Vehicule] = []
    
     var resp: Response? {
        didSet {
            self.didFinishFetch?()
        }
    }
   
    var isLoading: Bool = true {
        didSet { self.updateLoadingStatus?() }
    }
    var EmptyErrorMessage: String? {
        didSet { self.showEmptyErrorClosure?() }
    }
    var InvalidMessage: String? {
        didSet { self.InvalidClosure?() }
    }
    var error: Error? {
        didSet { self.showErrorClosure?() }
    }
    var Go2Box2HomeMessage : String? {
        didSet {  self.Go2Box2Home?() }
    }
    var showErrorClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var Go2Box2Home: (() -> ())?
    var didFinishFetch: (() -> ())?
    var showEmptyErrorClosure: (() -> ())?
    var InvalidClosure: (() -> ())?
    
    private var LoginRepository: LoginRepository?
    
    
    init(LoginRepository : LoginRepository) { self.LoginRepository = LoginRepository }
    
//    func CheckInternet(vc:UIViewController) {
//        self.LoginRepository?.DoCheckInternet(vc: vc)
//    }
//
    
   
    
    func Login(phone:String) {
        

            self.LoginRepository?.doLogin(phone: phone,completion: { (json, error) in
                if  let error = error {
                    self.error = error
                    self.isLoading = false
                    return
                } else if let json = json {
                    let SwiftyJson = JSON(json)
                    let message = SwiftyJson[0]["message"].stringValue
                    if (message != "Success") {
                        self.Go2Box2HomeMessage = message
                        self.isLoading = false
                        return
                    } else {
                        let response : Response!
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: json[0])
                            response = try Response(data: jsonData)
                            SessionManager.currentSession.signIn(response: response)
                            {
                                
                                self.resp = response
                                SocketIOManager.sharedInstance.establishConnection()
                            }
                        }catch{
                            self.error = error
                            self.isLoading = false
                            return
                        }
                        

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                           
                           self.isLoading = false
                        }
                    }
                }
                
            })
    }

}
