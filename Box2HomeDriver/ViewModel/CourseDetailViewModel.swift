//
//  CourseDetailViewModel.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/3/19.
//  Copyright © 2019 MacHD. All rights reserved.
//
import Foundation
import GoogleMaps
import SwiftyJSON
import Alamofire

class CourseDetailViewModel {
    private var CourseDetailRepository: CourseDetailRepository?
    
    
    init(CourseDetailRepository : CourseDetailRepository
        ) { self.CourseDetailRepository = CourseDetailRepository
    }
    
    var error: Error? {
        didSet { self.showErrorClosure?() }
    }
    
    var showErrorClosure: (() -> ())?
    
     func uploadSignatureImage(image: UIImage, codeCourse: String, type: String, vc: UIViewController)  {
        let url =  "https://api.box2home.xyz/mob/uploadSignature"
        let queryParams: [String : String] = [
            "codeCourse" : codeCourse,
            "type" : type
        ]
        self.CourseDetailRepository?.doUploadSignatureImage(image: image, url: url, queryParams: queryParams, vc: vc)
    }
    
    func setPointEnlevement(codeCourse: String, pointEnlevement: String)  {
        let url =  "https://api.box2home.xyz/mob/setPointEnlevement"
        let params = ["codeCourse" : codeCourse,
                      "pointEnlevement"   : pointEnlevement]

        self.CourseDetailRepository?.doSetPointEnlevement(url: url, params: params, completion: { (json, error) in
            if  let error = error {
                print(error.localizedDescription)
                self.error = error
                return
            } else if let json = json {
                let json = JSON(json)
                print("doSetPointEnlevement Response: \n")
                print(json.description)
            }
        })
    }
    
    func uploadPhotos(images: [UIImage], codeCourse: String, type: String, vc: UIViewController)  {
        let url =  "https://api.box2home.xyz/mob/uploadPhoto"
        let queryParams: [String : String] = [
            "codeCourse" : codeCourse,
            "type" : type
        ]
        self.CourseDetailRepository?.doUploadPhotos(arrImage: images, url: url, queryParams: queryParams, vc: vc )
    }
    
    func drawPath(startLocation : CLLocation, endLocation : CLLocation, mapView : GMSMapView){
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=AIzaSyDK4545yE-PVf_5HmcKj9IBIusckDLoNmg"
        
        self.CourseDetailRepository?.doDrawPath(url: url, completion: { (data, error) in
            if  let error = error {
                self.error = error
                return
            } else if let data = data {
                let json = JSON(data)
                //                print(json.description)
                let routes = json["routes"].arrayValue
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = mapView
                }
            }
        })
    }
    
}
