//
//  LoginRepository.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/1/19.
//  Copyright © 2019 MacHD. All rights reserved.
//



import Alamofire
import UIKit
struct LoginRepository{
     static let sharedInstance = LoginRepository()
     typealias WebServiceResponse = ([[String: Any]]?,Error?) -> Void
     let urlAPI = "https://api.box2home.xyz/mob/loginChauffeur"

//    func DoCheckInternet(vc: UIViewController) {
//        
//        if (!Network.reachability.isReachable){
//            let alert = UIAlertController(title: "Attention", message: "NO INTERNET CONNECTION !!", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(action)
//            vc.present(alert, animated:  true , completion: nil)}
//    }
    
    func doLogin( phone:String ,completion:    @escaping WebServiceResponse)  {
        
        let param = ["phone" : phone]
        guard let urlToExecute = URL(string: urlAPI) else {return}
        AF.request(urlToExecute, method: .post, parameters: param).validate().responseJSON {
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
