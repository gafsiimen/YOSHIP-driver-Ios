//
//  SocketViewModel.swift
//  Box2HomeDriver
//
//  Created by MacHD on 5/28/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class SocketViewModel {
    private var SocketRepository: SocketRepository?
    init(SocketRepository : SocketRepository)
    {
        self.SocketRepository = SocketRepository
    }
    
    
    func uploadPhotos(images: [UIImage], codeCourse: String, type: String)  {
        let url =  "https://api.box2home.xyz/mob/uploadPhoto"
        let queryParams: [String : String] = [
            "codeCourse" : codeCourse,
            "type" : type
        ]
        self.SocketRepository?.doUploadPhotos(arrImage: images, url: url, queryParams: queryParams)
    }
    
    func uploadSignature(image: UIImage, codeCourse: String, type: String)  {
        let url =  "https://api.box2home.xyz/mob/uploadSignature"
        let queryParams: [String : String] = [
            "codeCourse" : codeCourse,
            "type" : type
        ]
        self.SocketRepository?.doUploadSignatureImage(image: image, url: url, queryParams: queryParams)
    }
    
    func setPointEnlevement(codeCourse: String, pointEnlevement: String)  {
        let url =  "https://api.box2home.xyz/mob/setPointEnlevement"
        let params = ["codeCourse" : codeCourse,
                      "pointEnlevement"   : pointEnlevement]
        
        self.SocketRepository?.doSetPointEnlevement(url: url, params: params, completion: { (json, error) in
            if  let error = error {
                print(error.localizedDescription)
                return
            } else if let json = json {
                let json = JSON(json)
                print("doSetPointEnlevement Response: \n")
                print(json.description)
            }
        })
    }
    
}
