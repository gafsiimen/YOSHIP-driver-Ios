//
//  chauffeurObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class chauffeurObject: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var label : String = ""
    @objc dynamic var latitude : Double = 0.0
    @objc dynamic var longitude : Double = 0.0
    @objc dynamic var vehicules : [vehiculeObject] = []
    @objc dynamic var heading : Int = 0
    @objc dynamic var lastname : String = ""
    @objc dynamic var firstname : String = ""
    @objc dynamic var manutention : Bool = false
    @objc dynamic var phone : String = ""
    @objc dynamic var avatarURL : String = ""
    @objc dynamic var code : String = ""
    @objc dynamic var companyName : String = ""
    @objc dynamic var moyenneEtoiles : Double = 0.0
    @objc dynamic var avis : String = ""
    @objc dynamic var immatriculation : String = ""
    @objc dynamic var onDuty : Bool = false
    @objc dynamic var coursesInPipe : [String] = []
    @objc dynamic var status : Int = 0
    @objc dynamic var vehiculeId : Int = 0
    @objc dynamic var deviceInfo : String = ""
    @objc dynamic var lastLogoutAt : String = ""
    @objc dynamic var lastLoginAt : String = ""
    @objc dynamic var etat : Int = 0
    @objc dynamic var vehiculeType : String = ""
}
