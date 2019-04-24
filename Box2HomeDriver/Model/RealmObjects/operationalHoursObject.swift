//
//  operationalHoursObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class operationalHoursObject: Object {
     @objc dynamic var dayOfWeek : dayOfWeekObject = dayOfWeekObject()
     @objc dynamic var openTime : String = ""
     @objc dynamic var closeTime : String = ""
     @objc dynamic var deliveryWindow : Int = 0

}
