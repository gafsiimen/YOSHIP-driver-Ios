//
//  canalVenteObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class canalVenteObject: Object {
    @objc dynamic var configs : configsObject = configsObject()
    @objc dynamic var code : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var articleFamilies : [articleFamilyObject] = []
}
