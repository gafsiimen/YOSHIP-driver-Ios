//
//  CourseObject.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

final class CourseObject: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var code : String = ""
    @objc dynamic var courseSource : String = ""
    @objc dynamic var adresseDepart : adresseObject = adresseObject()
    @objc dynamic var pointEnlevement : String = ""
    @objc dynamic var vehiculeType : String = ""
    @objc dynamic var moyenPaiement : moyenPaiementObject = moyenPaiementObject()
    @objc dynamic var observation : String = ""
    @objc dynamic var observationArrivee : String = ""
    @objc dynamic var factures : String = ""
    @objc dynamic var adresseArrivee : adresseObject = adresseObject()
    @objc dynamic var chauffeur : chauffeurObject = chauffeurObject()
    @objc dynamic var vehicule : vehiculeObject = vehiculeObject()
    @objc dynamic var lettreDeVoiture : lettreDeVoitureObject = lettreDeVoitureObject()
    @objc dynamic var contactArrivee : contactObject = contactObject()
    @objc dynamic var contactDepart : contactObject = contactObject()
    @objc dynamic var nombreColis : Int = 0
    @objc dynamic var manutention : Bool = false
    @objc dynamic var manutentionDouble : Bool = false
    @objc dynamic var estimatedKM : Double = 0.0
    @objc dynamic var status : statusObject = statusObject()
    @objc dynamic var commande : commandeObject = commandeObject()
    @objc dynamic var dateDemarrage : String = ""
    @objc dynamic var dateAcceptation : String = ""
    @objc dynamic var dateEnlevement : String = ""
    @objc dynamic var dateLivraison : String = ""
    @objc dynamic var dateAffirmationFin : String = ""
    @objc dynamic var createdAt : String = ""
    @objc dynamic var montantHT : String = ""
    @objc dynamic var token : String = ""
    @objc dynamic var signaturesImages : [signatureImageObject] = []
    @objc dynamic var colisImages : [String] = []
    @objc dynamic var nomSociete : String = ""
    @objc dynamic var adresseFacturation : adresseObject = adresseObject()
    @objc dynamic var scannedDocs : [String] = []
    @objc dynamic var articles : [String] = []
    @objc dynamic var articleFamilies : [articleFamilyObject] = []
    @objc dynamic var noteInterne : String = ""
    @objc dynamic var nonEnvoiMail : Bool = false
    @objc dynamic var isStatusChangedManually : Bool = false
    @objc dynamic var dateDemarrageMeta : dateDemarrageMetaObject = dateDemarrageMetaObject()
    @objc dynamic var codeCorner : String = ""
    
    
    override static func primaryKey() -> String? {
        return "code"
    }
}
