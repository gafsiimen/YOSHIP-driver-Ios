//
//  vehicule_categoryObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class vehicule_categoryObject: Object {
    @objc dynamic var code : String = ""
    @objc dynamic var type : String = ""
    @objc dynamic var volumeMax : Int = 0
    @objc dynamic var id : Int = 0
}
