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
    let estimatedKM : Double
    var status : status
    let commande : commande
    let dateDemarrage : String
    let dateAcceptation : String
    let dateEnlevement : String
    let dateLivraison : String
    let dateAffirmationFin : String
    let createdAt : String
    let montantHT : String
    var token : String?
    let signaturesImages : [signatureImage]
    let colisImages : [String]
    var nomSociete : String?
    var adresseFacturation : adresse?
    let scannedDocs : [String]
    let articles : [String]
    let articleFamilies : [articleFamily]
    var noteInterne : String?
    var nonEnvoiMail : Bool?
    let isStatusChangedManually : Bool
    let dateDemarrageMeta : dateDemarrageMeta
    let codeCorner : String
    
    init(id : Int ,code : String,courseSource : String, adresseDepart : adresse, pointEnlevement : String, vehiculeType : String ,moyenPaiement : moyenPaiement,observation : String, observationArrivee : String,factures : String, adresseArrivee : adresse , chauffeur : chauffeur, vehicule : vehicule, lettreDeVoiture : lettreDeVoiture, contactArrivee : contact, contactDepart : contact ,nombreColis : Int, manutention : Bool, manutentionDouble : Bool, estimatedKM : Double, status : status, commande : commande ,dateDemarrage : String, dateAcceptation : String, dateEnlevement : String, dateLivraison : String, dateAffirmationFin : String ,createdAt : String, montantHT : String, signaturesImages : [signatureImage], colisImages : [String] , scannedDocs : [String],articles :[String],articleFamilies : [articleFamily], isStatusChangedManually : Bool, dateDemarrageMeta : dateDemarrageMeta,codeCorner : String) {
        self.id = id
        self.code = code
        self.courseSource = courseSource
        self.adresseDepart = adresseDepart
        self.pointEnlevement = pointEnlevement
        self.vehiculeType = vehiculeType
        self.moyenPaiement = moyenPaiement
        self.observation = observation
        self.observationArrivee = observationArrivee
        self.factures = factures
        self.adresseArrivee = adresseArrivee
        self.chauffeur = chauffeur
        self.vehicule = vehicule
        self.lettreDeVoiture = lettreDeVoiture
        self.contactArrivee = contactArrivee
        self.contactDepart = contactDepart
        self.nombreColis = nombreColis
        self.manutention = manutention
        self.manutentionDouble = manutentionDouble
        self.estimatedKM = estimatedKM
        self.status = status
        self.commande = commande
        self.dateDemarrage = dateDemarrage
        self.dateAcceptation = dateAcceptation
        self.dateEnlevement = dateEnlevement
        self.dateLivraison = dateLivraison
        self.dateAffirmationFin = dateAffirmationFin
        self.createdAt = createdAt
        self.montantHT = montantHT
        self.signaturesImages = signaturesImages
        self.colisImages = colisImages
        self.scannedDocs = scannedDocs
        self.articles = articles
        self.articleFamilies = articleFamilies
        self.isStatusChangedManually = isStatusChangedManually
        self.dateDemarrageMeta = dateDemarrageMeta
        self.codeCorner = codeCorner
    }
}




