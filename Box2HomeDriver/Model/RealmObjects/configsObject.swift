//
//  configsObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class configsObject: Object {
    @objc dynamic var priceBasedOnPurchaseAmount : Bool = false
    @objc dynamic var priceBasedOnNBitems : Bool = false
    @objc dynamic var fixedPriceIncludeManutention : Bool = false
    @objc dynamic var operationalHours : [operationalHoursObject] = []
}
