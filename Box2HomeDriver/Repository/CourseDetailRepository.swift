//
//  CourseDetailRepository.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/3/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Alamofire
import GoogleMaps
import UIKit

struct CourseDetailRepository{
    static let sharedInstance = CourseDetailRepository()
     typealias WebServiceResponse = (Data?,Error?) -> Void
    
    func doDrawPath(url: String, completion: @escaping WebServiceResponse){
        AF.request(url).responseJSON { response in
//            print(response.request as Any)
//            print(response.response as Any)
//            print(response.data as Any)
//            print(response.result as Any)
            if let error = response.error {
                completion(nil,error)
            } else  if let  data = response.data {
                completion(data,nil)
            }
        }
    }
}
