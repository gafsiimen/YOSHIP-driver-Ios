//
//  vehiculeObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class vehiculeObject: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var status : Int = 0
    @objc dynamic var vehicule_category : vehicule_categoryObject = vehicule_categoryObject()
    @objc dynamic var haillon : Bool = false
    @objc dynamic var denomination : String = ""
    @objc dynamic var immatriculation : String = ""
   
}
