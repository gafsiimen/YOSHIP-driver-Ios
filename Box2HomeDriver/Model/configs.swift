//
//  configs.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
struct configs {
    let priceBasedOnPurchaseAmount : Bool
    let priceBasedOnNBitems : Bool
    let fixedPriceIncludeManutention : Bool
    var operationalHours : [operationalHours]?
    
    init(priceBasedOnPurchaseAmount : Bool, priceBasedOnNBitems : Bool,fixedPriceIncludeManutention : Bool,operationalHours : [operationalHours]) {
        self.priceBasedOnPurchaseAmount = priceBasedOnPurchaseAmount
        self.priceBasedOnNBitems = priceBasedOnNBitems
        self.fixedPriceIncludeManutention = fixedPriceIncludeManutention
        self.operationalHours = operationalHours
    }
    init(priceBasedOnPurchaseAmount : Bool, priceBasedOnNBitems : Bool,fixedPriceIncludeManutention : Bool) {
        self.priceBasedOnPurchaseAmount = priceBasedOnPurchaseAmount
        self.priceBasedOnNBitems = priceBasedOnNBitems
        self.fixedPriceIncludeManutention = fixedPriceIncludeManutention
    }
}
