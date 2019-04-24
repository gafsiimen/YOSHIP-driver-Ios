//
//  LoginModelView.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/1/19.
//  Copyright © 2019 MacHD. All rights reserved.
//


import SwiftyJSON
import UIKit
class LoginViewModel {
    var vehicules : [Vehicule] = []
    
    private var chauffeur: Chauffeur? {
        didSet {
            self.didFinishFetch?()
        }
    }
   
    var isLoading: Bool = true {
        didSet { self.updateLoadingStatus?() }
    }
    var EmptyErrorMessage: String? {
        didSet { self.showEmptyErrorClosure?() }
    }
    var InvalidMessage: String? {
        didSet { self.InvalidClosure?() }
    }
    var error: Error? {
        didSet { self.showErrorClosure?() }
    }
    var Go2Box2HomeMessage : String? {
        didSet {  self.Go2Box2Home?() }
    }
    var showErrorClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var Go2Box2Home: (() -> ())?
    var didFinishFetch: (() -> ())?
    var showEmptyErrorClosure: (() -> ())?
    var InvalidClosure: (() -> ())?
    
    private var LoginRepository: LoginRepository?
    
    
    init(LoginRepository : LoginRepository) { self.LoginRepository = LoginRepository }
    
//    func CheckInternet(vc:UIViewController) {
//        self.LoginRepository?.DoCheckInternet(vc: vc)
//    }
//    
    func Login(phone:String) {
        

            self.LoginRepository?.doLogin(phone: phone,completion: { (json, error) in
                if  let error = error {
                    self.error = error
                    self.isLoading = false
                    return
                } else if let json = json {
                    let SwiftyJson = JSON(json)
                    let message = SwiftyJson[0]["message"].stringValue
                    if (message != "Success") {
                        self.Go2Box2HomeMessage = message
                        self.isLoading = false
                        return
                    } else {
                        let response : Response!
//                        self.chauffeurParsing(json)
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: json[0])
                            response = try Response(data: jsonData)
                        }catch{
                            self.error = error
                            self.isLoading = false
                            return
                        }
                    
                        SessionManager.currentSession.signIn(response: response)
                        {
                            self.chauffeur = response!.authToken!.chauffeur!
                            SocketIOManager.sharedInstance.establishConnection()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                           self.isLoading = false
                        }
                    }
                }
                
            })
    }
    
    fileprivate func chauffeurParsing(_ json: JSON) {
        let veh = json[0]["authToken"]["chauffeur"]["vehicules"].arrayValue
        for car in veh {
            self.vehicules.append(
                Vehicule(denomination: car["denomination"].stringValue,
                         haillon: car["haillon"].boolValue,
                         immatriculation: car["immatriculation"].stringValue,
                         id: car["id"].intValue, status: car["status"].intValue,
                         vehiculeCategory: VehiculeCategory( type: car["vehicule_category"]["type"].stringValue,
                                                             volumeMax: car["vehicule_category"]["volumeMax"].intValue,
                                                             code: car["vehicule_category"]["code"].stringValue,
                                                             id: car["vehicule_category"]["id"].intValue))
          
                        )
        }
        self.chauffeur = Chauffeur(etat: json[0]["authToken"]["chauffeur"]["etat"].intValue,
                                   manutention: json[0]["authToken"]["chauffeur"]["manutention"].boolValue,
                                   companyName: json[0]["authToken"]["chauffeur"]["companyName"].stringValue,
                                   avatarURL: json[0]["authToken"]["chauffeur"]["avatarURL"].stringValue,
                                   code: json[0]["authToken"]["chauffeur"]["code"].stringValue,
                                   vehiculeType: json[0]["authToken"]["chauffeur"]["vehiculeType"].stringValue,
                                   lastLogoutAt: json[0]["authToken"]["chauffeur"]["lastLogoutAt"].stringValue,
                                   avis: json[0]["authToken"]["chauffeur"]["avis"].stringValue,
                                   latitude: json[0]["authToken"]["chauffeur"]["latitude"].doubleValue,
                                   heading: json[0]["authToken"]["chauffeur"]["heading"].intValue,
                                   lastLoginAt: json[0]["authToken"]["chauffeur"]["lastLoginAt"].stringValue,
                                   immatriculation: json[0]["authToken"]["chauffeur"]["immatriculation"].stringValue,
                                   deviceInfo: json[0]["authToken"]["chauffeur"]["deviceInfo"].stringValue,
                                   moyenneEtoiles: json[0]["authToken"]["chauffeur"]["moyenneEtoiles"].doubleValue,
                                   coursesInPipe: json[0]["authToken"]["chauffeur"]["coursesInPipe"].arrayObject as? [String],
                                   firstname: json[0]["authToken"]["chauffeur"]["firstname"].stringValue,
                                   lastname: json[0]["authToken"]["chauffeur"]["lastname"].stringValue,
                                   onDuty: json[0]["authToken"]["chauffeur"]["onDuty"].boolValue,
                                   longitude: json[0]["authToken"]["chauffeur"]["longitude"].doubleValue,
                                   vehiculeID: json[0]["authToken"]["chauffeur"]["vehiculeId"].intValue,
                                   phone: json[0]["authToken"]["chauffeur"]["phone"].stringValue,
                                   status: json[0]["authToken"]["chauffeur"]["status"].intValue,
                                   vehicules: self.vehicules,
                                   id: json[0]["authToken"]["chauffeur"]["id"].intValue)
//        self.chauffeur = Chauffeur(
//            id: json[0]["authToken"]["chauffeur"]["id"].intValue,
//            label: json[0]["authToken"]["chauffeur"]["label"].stringValue,
//            latitude: json[0]["authToken"]["chauffeur"]["latitude"].doubleValue,
//            longitude: json[0]["authToken"]["chauffeur"]["longitude"].doubleValue,
//            vehicules: self.vehicules ,
//            heading: json[0]["authToken"]["chauffeur"]["heading"].intValue,
//            lastname: json[0]["authToken"]["chauffeur"]["lastname"].stringValue,
//            firstname: json[0]["authToken"]["chauffeur"]["firstname"].stringValue,
//            manutention: json[0]["authToken"]["chauffeur"]["manutention"].boolValue,
//            phone: json[0]["authToken"]["chauffeur"]["phone"].stringValue,
//            avatarURL: json[0]["authToken"]["chauffeur"]["avatarURL"].stringValue,
//            code: json[0]["authToken"]["chauffeur"]["code"].stringValue,
//            companyName: json[0]["authToken"]["chauffeur"]["companyName"].stringValue,
//            moyenneEtoiles: json[0]["authToken"]["chauffeur"]["moyenneEtoiles"].doubleValue,
//            avis: json[0]["authToken"]["chauffeur"]["avis"].stringValue,
//            immatriculation: json[0]["authToken"]["chauffeur"]["immatriculation"].stringValue,
//            onDuty: json[0]["authToken"]["chauffeur"]["onDuty"].boolValue,
//            coursesInPipe: json[0]["authToken"]["chauffeur"]["coursesInPipe"].arrayObject as! [String],
//            status: json[0]["authToken"]["chauffeur"]["status"].intValue,
//            vehiculeId: json[0]["authToken"]["chauffeur"]["vehiculeId"].intValue,
//            deviceInfo: json[0]["authToken"]["chauffeur"]["deviceInfo"].stringValue,
//            lastLogoutAt: json[0]["authToken"]["chauffeur"]["lastLogoutAt"].stringValue,
//            lastLoginAt: json[0]["authToken"]["chauffeur"]["lastLoginAt"].stringValue,
//            etat: json[0]["authToken"]["chauffeur"]["etat"].intValue,
//            vehiculeType: json[0]["authToken"]["chauffeur"]["vehiculeType"].stringValue)
    }
}
