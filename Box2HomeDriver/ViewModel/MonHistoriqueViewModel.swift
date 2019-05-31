//
//  MonHistoriqueViewModel.swift
//  Box2HomeDriver
//
//  Created by MacHD on 5/31/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import SwiftyJSON
class MonHistoriqueViewModel {
    private var MonHistoriqueRepository: MonHistoriqueRepository?
    
    init(MonHistoriqueRepository : MonHistoriqueRepository) {
        self.MonHistoriqueRepository = MonHistoriqueRepository
    }
    
    func GetHistory() -> [Course] {
        var coursesArray: [Course] = []
        self.MonHistoriqueRepository?.doGetHistory( completion: { (json, error) in
            if  let error = error {
                print(error)
                return
            } else if let json = json {
                let SwiftyJson = JSON(json)
                let arr = SwiftyJson[0].arrayValue
                do{
                    for element in arr {
                        let jsonData = try JSONSerialization.data(withJSONObject: element)
                        let course = try Course(data: jsonData)
                         print(course.description)
                    }
                }catch{print(error)}
                
//                let SwiftyJson = JSON(json)
//                let courses = SwiftyJson[0]["Data"].arrayValue
//                for element in courses{
//                    print(element["code"].string)
//                }
//                    print(courses.description)
            }
            
        })
//        print(coursesArray.description)
        return coursesArray
    }
    
    
    
}
