//
//  adresseObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class adresseObject: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var label : String = ""
    @objc dynamic var address : String = ""
    @objc dynamic var latitude : Double = 0.0
    @objc dynamic var longitude : Double = 0.0
    @objc dynamic var postalCode : Int = 0
    @objc dynamic var operationalHours : [operationalHoursObject] = []
    
}
