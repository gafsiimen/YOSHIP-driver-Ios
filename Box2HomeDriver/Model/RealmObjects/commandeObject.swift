//
//  commandeObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class commandeObject: Object {
    @objc dynamic var canalVente : canalVenteObject = canalVenteObject()
    @objc dynamic var client : clientObject = clientObject()
    @objc dynamic var courses : [CourseObject] = []
    @objc dynamic var promotion : String = ""
    @objc dynamic var commandeExtra : String = ""
    @objc dynamic var montantGlobalHt : Double = 0.0
    @objc dynamic var codeTva : Int = 0
    @objc dynamic var montantGlobalTtc : Int = 0
    @objc dynamic var etatPaiement : String = ""
    @objc dynamic var collaborateur : collaborateurObject = collaborateurObject()
}
