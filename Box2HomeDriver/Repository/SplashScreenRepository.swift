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
//        NetworkManager.isReachable { networkManagerInstance in
//            print("Network is available")
//        }
        NetworkManager.sharedInstance.reachability.whenReachable = { reachability in
            print("reachable")
        }
//        NetworkManager.isUnreachable { networkManagerInstance in
//            print("Network is Unavailable")
//        }
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
