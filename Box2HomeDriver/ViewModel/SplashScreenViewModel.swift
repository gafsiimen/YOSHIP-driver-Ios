//
//  SplashScreenViewModel.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/6/19.
//  Copyright © 2019 MacHD. All rights reserved.
//


import SwiftyJSON

class SplashScreenViewModel {
    private var SplashScreenRepository: SplashScreenRepository?
//    private var SocketRepository: SocketRepository?
    
    init(SplashScreenRepository : SplashScreenRepository
//        ,SocketRepository: SocketRepository
        ) { self.SplashScreenRepository = SplashScreenRepository
//        self.SocketRepository = SocketRepository
    }
    
    var resp: Response? {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    var error: Error? {
        didSet { self.showErrorClosure?() }
    }
    var GoodVersionMessage: String? {
        didSet { self.showGoodVersionClosure?() }
    }
//    var ConnectedMessage: String? {
//        didSet { self.showConnectedClosure?() }
//    }
//    var NoInternetMessage: String? {
//        didSet { self.showNoInternetClosure?() }
//    }
    var BadVersionMessage: String? {
        didSet { self.showBadVersionClosure?() }
    }
    var didFinishFetch: (() -> ())?
    var showErrorClosure: (() -> ())?
    var showGoodVersionClosure: (() -> ())?
    var showBadVersionClosure: (() -> ())?
//    var showConnectedClosure: (() -> ())?
//    var showNoInternetClosure: (() -> ())?
    
//    func CheckInternet() {
//       let code = SocketRepository?.doCheckInternet()
//        if code == 1 {ConnectedMessage = "INTERNET WORKING !"} else { NoInternetMessage = "NO INTERNET !"}
//    }
    func CheckInternet() {
        self.SplashScreenRepository?.DoCheckInternet()
    }
    func CheckVersion() {
            self.SplashScreenRepository?.doCheckVersion(completion: { (json, error) in
                if  let error = error {
                    self.error = error
                    return
                } else if let json = json {
                    let json = JSON(json)
//                    print(json.description)
                    
                    ////  Comparing versions here
//                    print(json[0]["response"]["version"].stringValue)
//                    print(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
                    ////
                  
                         self.GoodVersionMessage = "GoodVersion"
                         self.BadVersionMessage = "BadVersion"
                         self.BadVersionMessage = "BadVersion2"
                }
                
            })
    }
    
    
    
    func Login(phone:String) {
        
        
        self.SplashScreenRepository?.doLogin(phone: phone,completion: { (json, error) in
            if  let error = error {
                self.error = error
                return
            } else if let json = json {
                let SwiftyJson = JSON(json)
                let message = SwiftyJson[0]["message"].stringValue
                if (message != "Success") {
                    return
                } else {
                    let response : Response!
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: json[0])
                        response = try Response(data: jsonData)
                        print("MY USELESS RESPONSE: ",response.description)
                    }catch{
                        self.error = error
                        return
                    }
                    
                }
            }
            
        })
    }
}
