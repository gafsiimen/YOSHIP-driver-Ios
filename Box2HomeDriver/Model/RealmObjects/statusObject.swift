//
//  statusObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class statusObject: Object {
    @objc dynamic var color : String = ""
    @objc dynamic var code : String = ""
    @objc dynamic var label : String = ""
}
