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
                    print(json.description)
                    
                    ////  Comparing versions here
                    print(json[0]["response"]["version"].stringValue)
                    print(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
                    ////
                  
                         self.GoodVersionMessage = "GoodVersion"
                         self.BadVersionMessage = "BadVersion"
                         self.BadVersionMessage = "BadVersion2"
                }
                
            })
    }
}
