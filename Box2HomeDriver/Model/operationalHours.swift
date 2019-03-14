//
//  operationalHours.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/12/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
struct operationalHours  {
    let dayOfWeek : dayOfWeek
    let openTime : String
    let closeTime : String
    let deliveryWindow : Int
    
    init(dayOfWeek : dayOfWeek, openTime : String, closeTime : String, deliveryWindow : Int) {
        self.dayOfWeek = dayOfWeek
        self.openTime = openTime
        self.closeTime = closeTime
        self.deliveryWindow = deliveryWindow
    }
    
}
