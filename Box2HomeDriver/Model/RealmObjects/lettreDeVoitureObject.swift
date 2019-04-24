//
//  lettreDeVoitureObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class lettreDeVoitureObject: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var code : String = ""
    @objc dynamic var reference : String = ""
}
