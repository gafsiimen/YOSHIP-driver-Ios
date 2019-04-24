//
//  signatureImageObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class signatureImageObject: Object {
    @objc dynamic var type : String = ""
    @objc dynamic var url : String = ""
}
