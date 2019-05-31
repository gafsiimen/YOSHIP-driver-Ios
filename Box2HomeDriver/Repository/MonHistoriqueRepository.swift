//
//  MonHistoriqueRepository.swift
//  Box2HomeDriver
//
//  Created by MacHD on 5/31/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import Alamofire

struct MonHistoriqueRepository {
    static let sharedInstance = MonHistoriqueRepository()
    typealias WebServiceResponse = ([[String: Any]]?,Error?) -> Void
    let urlAPIHistory = "https://api.box2home.xyz/mob/coursesHistoryChauffeur"

    func doGetHistory( completion:    @escaping WebServiceResponse)  {
        guard let urlToExecute = URL(string: urlAPIHistory) else {return}
        
        AF.request(urlToExecute, method: .get,headers: ["X-Auth-Token": UserDefaults.standard.string(forKey: "token")!]).validate().responseJSON {
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
