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
    var vehicules : [vehicule] = []
    
    private var Chauffeur: chauffeur? {
        didSet {
            self.didFinishFetch?()
        }
    }
   
    var isLoading: Bool = false {
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
        
        if (phone == "") {
                 self.EmptyErrorMessage = "Ce champ est obligatoire!"
                 self.isLoading = false
                 return
                }
        else if (!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phone)))
        {
            self.InvalidMessage = "Veuillez introduire un numéro valide!"
            self.isLoading = false
            return
        } else {
            self.LoginRepository?.doLogin(phone: phone,completion: { (json, error) in
                if  let error = error {
                    self.error = error
                    self.isLoading = false
                    return
                } else if let json = json {
                    let json = JSON(json)
                    let message = json[0]["message"].stringValue
                    if (message != "Success") {
                        self.Go2Box2HomeMessage = message
                        self.isLoading = false
                        return
                    } else {
                        self.isLoading = true
                        self.chauffeurParsing(json)
                        SessionManager.currentSession.signIn(message: message, authToken: json[0]["authToken"]["value"].stringValue, code: json[0]["code"].stringValue, coursesInPipeStats: coursesInPipeStats(INPROGRESS: json[0]["coursesInPipeStats"]["INPROGRESS"].intValue, ASSIGNED: json[0]["coursesInPipeStats"]["ASSIGNED"].intValue), chauffeur: self.Chauffeur!)
                        print(SessionManager.currentSession.chauffeur!.firstname)
                    }
                }
                
            })
        }
       
    }
    
    fileprivate func chauffeurParsing(_ json: JSON) {
        let veh = json[0]["authToken"]["chauffeur"]["vehicules"].arrayValue
        for car in veh {
            self.vehicules.append(
                vehicule(id: car["id"].intValue,
                         status: car["status"].intValue,
                         vehicule_category: Vehicule_category(
                            code: car["vehicule_category"]["code"].stringValue,
                            type: car["vehicule_category"]["type"].stringValue,
                            volumeMax:car["vehicule_category"]["volumeMax"].intValue,
                            id: car["vehicule_category"]["id"].intValue),
                         haillon: car["haillon"].boolValue,
                         denomination: car["denomination"].stringValue,
                         immatriculation: car["immatriculation"].stringValue))
        }
        self.Chauffeur = chauffeur(
            id: json[0]["authToken"]["chauffeur"]["id"].intValue,
            label: json[0]["authToken"]["chauffeur"]["label"].stringValue,
            latitude: json[0]["authToken"]["chauffeur"]["latitude"].doubleValue,
            longitude: json[0]["authToken"]["chauffeur"]["longitude"].doubleValue,
            vehicules: self.vehicules ,
            heading: json[0]["authToken"]["chauffeur"]["heading"].intValue,
            lastname: json[0]["authToken"]["chauffeur"]["lastname"].stringValue,
            firstname: json[0]["authToken"]["chauffeur"]["firstname"].stringValue,
            manutention: json[0]["authToken"]["chauffeur"]["manutention"].boolValue,
            phone: json[0]["authToken"]["chauffeur"]["phone"].stringValue,
            avatarURL: json[0]["authToken"]["chauffeur"]["avatarURL"].stringValue,
            code: json[0]["authToken"]["chauffeur"]["code"].stringValue,
            companyName: json[0]["authToken"]["chauffeur"]["companyName"].stringValue,
            moyenneEtoiles: json[0]["authToken"]["chauffeur"]["moyenneEtoiles"].floatValue,
            avis: json[0]["authToken"]["chauffeur"]["avis"].stringValue,
            immatriculation: json[0]["authToken"]["chauffeur"]["immatriculation"].stringValue,
            onDuty: json[0]["authToken"]["chauffeur"]["onDuty"].boolValue,
            coursesInPipe: json[0]["authToken"]["chauffeur"]["coursesInPipe"].arrayObject as! [String],
            status: json[0]["authToken"]["chauffeur"]["status"].intValue,
            vehiculeId: json[0]["authToken"]["chauffeur"]["vehiculeId"].intValue,
            deviceInfo: json[0]["authToken"]["chauffeur"]["deviceInfo"].stringValue,
            lastLogoutAt: json[0]["authToken"]["chauffeur"]["lastLogoutAt"].stringValue,
            lastLoginAt: json[0]["authToken"]["chauffeur"]["lastLoginAt"].stringValue,
            etat: json[0]["authToken"]["chauffeur"]["etat"].intValue,
            vehiculeType: json[0]["authToken"]["chauffeur"]["vehiculeType"].stringValue)
    }
}
