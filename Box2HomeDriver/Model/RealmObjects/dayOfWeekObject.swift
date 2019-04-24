//
//  dayOfWeekObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class dayOfWeekObject: Object {
    @objc dynamic var label : String = ""
    @objc dynamic var code : String = ""
}
