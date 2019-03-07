//
//  SplashScreenRepository.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/6/19.
//  Copyright © 2019 MacHD. All rights reserved.
//



import Alamofire

struct SplashScreenRepository {
 static let sharedInstance = SplashScreenRepository()
    typealias WebServiceResponse = ([[String: Any]]?,Error?) -> Void
    let urlAPI = "https://api.box2home.xyz/api/system/versioning/getLastVersion"
    
    
    func DoCheckInternet() {
        switch Network.reachability.status {
        case .unreachable:
            print("\nunreachable Status")
        case .wwan:
            print("wwan")
        case .wifi:
            print("wifi")
        }
        print("\n********************")
        print("Reachability Summary")
        print("Status:", Network.reachability.status)
        print("HostName:", Network.reachability.hostname ?? "nil")
        print("Reachable:", Network.reachability.isReachable)
        print("Wifi:", Network.reachability.isReachableViaWiFi)
        print("********************\n")
    }
    
    func doCheckVersion( completion:    @escaping WebServiceResponse)  {
        let param = ["platform" : "ios",
                     "target"   : "driver"]
        guard let urlToExecute = URL(string: urlAPI) else {return}
        
        AF.request(urlToExecute, method: .get, parameters: param).validate().responseJSON {
            response in
            if let error = response.error {
                completion(nil,error)
            } else  if let  jsonArray = response.result.value as? [[String: Any]]{
                completion(jsonArray,nil)
            } else  if let  jsonDict = response.result.value as? [String: Any]{
                completion([jsonDict],nil)
            }
        }
        
    }
}
