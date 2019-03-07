//
//  Course.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation

struct Course {
    let id : Int
    let code : String
    let courseSource : String
    let adresseDepart : adresse
    let pointEnlevement : String
    let vehiculeType : String
    let moyenPaiement : moyenPaiement
    let observation : String
    let observationArrivee : String
    let factures : String
    let adresseArrivee : adresse
    let chauffeur : chauffeur
    let vehicule : vehicule
    let lettreDeVoiture : lettreDeVoiture
    let contactArrivee : contact
    let contactDepart : contact
    let nombreColis : Int
    let manutention : Bool
    let manutentionDouble : Bool
    let status : status
    let commande : commande
    let dateDemarrage : String
    let dateAcceptation : String
    let dateEnlevement : String
    let dateLivraison : String
    let dateAffirmationFin : String
    let createdAt : String
    let montantHT : String
    let token : String
    let nomSociete : String
    let adresseFacturation : adresse
    let scannedDocs : [scannedDoc]
    let articles : [article]
    let articleFamilies : [articleFamily]
    let noteInterne : String
    let nonEnvoiMail : Bool
    let isStatusChangedManually : Bool
}



