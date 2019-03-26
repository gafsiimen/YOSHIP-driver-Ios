//
//  dateDemarrageMeta.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/25/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
struct dateDemarrageMeta  {
    let closeTime : String
    let deliveryWindow : Int
    let openTime : String
    
    init(closeTime : String, deliveryWindow : Int, openTime : String) {
        self.closeTime = closeTime
        self.deliveryWindow = deliveryWindow
        self.openTime = openTime
    }
    
}
