//
//  commande.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
struct commande  {
    
    let canalVente : canalVente
    let client : client
    let courses : [Course]
    let promotion : String
    let commandeExtra : String
    let montantGlobalHt : Double
    let codeTva : Int
    let montantGlobalTtc : Int
    let etatPaiement : String
    let collaborateur : collaborateur
}
