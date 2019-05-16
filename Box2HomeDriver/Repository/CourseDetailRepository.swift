//
//  CourseDetailRepository.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/3/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

struct CourseDetailRepository{
    static let sharedInstance = CourseDetailRepository()
    typealias WebServiceResponse1 = (Data?,Error?) -> Void
    typealias WebServiceResponse2 = ([[String: Any]]?,Error?) -> Void
    
    
    
    func doSetPointEnlevement(url: String, params: [String:Any], completion: @escaping WebServiceResponse2)  {

        guard let urlToExecute = URL(string: url) else {return}
        
        AF.request(urlToExecute, method: .post, parameters: params, headers: ["X-Auth-Token": UserDefaults.standard.string(forKey: "token")!]).validate().responseJSON {
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
    
    
    
    
    func doUploadSignatureImage(image: UIImage,  url: String, queryParams: [String: String], vc: UIViewController){
        
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        if imageData != nil{
            
            var components = URLComponents(string: url)!
            components.queryItems = queryParams.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            
            var request = URLRequest(url: components.url!)
            print(request)
            request.setValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "X-Auth-Token") //**
            request.httpMethod = "POST"
            
            let boundary = NSString(format: NSUUID().uuidString as NSString)
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data;name=\"title\"\r\n\r\n").data(using:String.Encoding.utf8.rawValue)!)
            body.append("Hello".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            
            
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data;name=\"signatureFile\";filename=\"new_image.jpg\"\\r\n").data(using:String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Type: image/jpeg\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(imageData!)
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            
            request.httpBody = body
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data, error == nil
                else { // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    let alert = UIAlertController(title: "Oops!", message: "\(String(describing: error!.localizedDescription))", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    vc.present(alert, animated:  true , completion: nil)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 500 {
                    let alert = UIAlertController(title: "Oops!", message: "Server Error", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    vc.present(alert, animated:  true , completion: nil)
                }
                else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                //This can print your response in string formate
                let responseString = String(data: data, encoding: .utf8)
                //            let dictionary = data
                //            print("dictionary = \(dictionary)")
                print("responseString = \(String(describing: responseString!))")
                
//                do {
//                    self.response3 = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
//                    print(self.response3)
//
//                    if (((self.response3["Response"] as? [String : Any])?["status"]) as! String == "SUCCESS") {
//                        let message = (self.response3["Response"] as? [String : Any])?["message"] as? String
//                        SharedClass.sharedInstance.alert(view:self, message: message)
//                    } else {
//                        let message = (self.response3["Response"] as? [String : Any])?["message"] as? String
//                        SharedClass.sharedInstance.alert(view:self, message: message)
//                    }
//
//                } catch let error as NSError {
//                    print(error)
//                    print(error.localizedDescription)
//                }
            }
            
            task.resume()
            
        }
        
        
    }
    
//     func doUploadSignature(param:[String: Any],arrImage:[UIImage], url:String){
//
//        let headers: HTTPHeaders
//        headers = ["X-Auth-Token": UserDefaults.standard.string(forKey: "token")!,
//                   "Content-type": "multipart/form-data",
//                   "Content-Disposition" : "form-data"]
//
//        AF.upload(multipartFormData: { (multipartFormData) in
//
//            for (key, value) in param {
//                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
//            }
//
//            for img in arrImage {
//                guard let imgData = img.pngData() else { return }
//                multipartFormData.append(imgData, withName: "signatureFile", fileName: ("\(NSDate().timeIntervalSince1970 * 1000)" + ".png"), mimeType: "image/png")
//            }
//
//
//        },to: url,
//          method: .post,
//          headers: headers) .uploadProgress(queue: .main, closure: { progress in
//                            //Current upload progress of file
//                            print("Upload Progress: \(Int(progress.fractionCompleted * 100))%")
//                        })
//                        .responseJSON(completionHandler: { data in
//                            print(data.description)
//                            //Do what ever you want to do with response
//                        })
//    }
    

    
    
    
    
    func doDrawPath(url: String, completion: @escaping WebServiceResponse1){
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
