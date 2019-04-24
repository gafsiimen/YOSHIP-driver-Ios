//
//  Course.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.


// To parse the JSON, add this file to your project and do:
//
//   let course = try? newJSONDecoder().decode(Course.self, from: jsonData)

import Foundation

class Course: Codable {
    let createdAt: String?
    let dateEnlevement, observationArrivee, pointEnlevement: String?
    let montantHT: Double?
    let nombreColis: Int?
    let estimatedKM: Double?
    let id: Int?
    let articleFamilies: [ArticleFamily]?
    var status: Status?
    let observation: String?
    let chauffeur: Chauffeur?
    let manutention: Bool?
    let yusoRequestID: String?
    let adresseArrivee: Adresse?
    let dateAffirmationFin: String?
    let manutentionDouble: Bool?
    let courseSource: String?
    let lettreDeVoiture: LettreDeVoiture?
    let contactArrivee: Contact?
    let code: String?
    let articles: [String]?
    let commande: Commande?
    let factures, dateLivraison: String?
    let signaturesImages: [SignatureImage]?
    let adresseDepart: Adresse?
    let dateDemarrage: String?
    let isStatusChangedManually: Bool?
    let contactDepart: Contact?
    let codeCorner: String?
    let moyenPaiement: MoyenPaiement?
    let vehiculeType: String?
    let dateDemarrageMeta: DateDemarrageMeta?
    let dateAcceptation: String?
    let vehicule: Vehicule?
    let scannedDocs, colisImages: [String]?
    
    enum CodingKeys: String, CodingKey {
        case createdAt, dateEnlevement, observationArrivee, pointEnlevement, montantHT, nombreColis, estimatedKM, id, articleFamilies, status, observation, chauffeur, manutention
        case yusoRequestID = "YusoRequestID"
        case adresseArrivee, dateAffirmationFin, manutentionDouble, courseSource, lettreDeVoiture, contactArrivee, code, articles, commande, factures, dateLivraison, signaturesImages, adresseDepart, dateDemarrage, isStatusChangedManually, contactDepart, codeCorner, moyenPaiement, vehiculeType, dateDemarrageMeta, dateAcceptation, vehicule, scannedDocs, colisImages
    }
    
    init(createdAt: String?, dateEnlevement: String?, observationArrivee: String?, pointEnlevement: String?, montantHT: Double?, nombreColis: Int?, estimatedKM: Double?, id: Int?, articleFamilies: [ArticleFamily]?, status: Status?, observation: String?, chauffeur: Chauffeur?, manutention: Bool?, yusoRequestID: String?, adresseArrivee: Adresse?, dateAffirmationFin: String?, manutentionDouble: Bool?, courseSource: String?, lettreDeVoiture: LettreDeVoiture?, contactArrivee: Contact?, code: String?, articles: [String]?, commande: Commande?, factures: String?, dateLivraison: String?, signaturesImages: [SignatureImage]?, adresseDepart: Adresse?, dateDemarrage: String?, isStatusChangedManually: Bool?, contactDepart: Contact?, codeCorner: String?, moyenPaiement: MoyenPaiement?, vehiculeType: String?, dateDemarrageMeta: DateDemarrageMeta?, dateAcceptation: String?, vehicule: Vehicule?, scannedDocs: [String]?, colisImages: [String]?) {
        self.createdAt = createdAt
        self.dateEnlevement = dateEnlevement
        self.observationArrivee = observationArrivee
        self.pointEnlevement = pointEnlevement
        self.montantHT = montantHT
        self.nombreColis = nombreColis
        self.estimatedKM = estimatedKM
        self.id = id
        self.articleFamilies = articleFamilies
        self.status = status
        self.observation = observation
        self.chauffeur = chauffeur
        self.manutention = manutention
        self.yusoRequestID = yusoRequestID
        self.adresseArrivee = adresseArrivee
        self.dateAffirmationFin = dateAffirmationFin
        self.manutentionDouble = manutentionDouble
        self.courseSource = courseSource
        self.lettreDeVoiture = lettreDeVoiture
        self.contactArrivee = contactArrivee
        self.code = code
        self.articles = articles
        self.commande = commande
        self.factures = factures
        self.dateLivraison = dateLivraison
        self.signaturesImages = signaturesImages
        self.adresseDepart = adresseDepart
        self.dateDemarrage = dateDemarrage
        self.isStatusChangedManually = isStatusChangedManually
        self.contactDepart = contactDepart
        self.codeCorner = codeCorner
        self.moyenPaiement = moyenPaiement
        self.vehiculeType = vehiculeType
        self.dateDemarrageMeta = dateDemarrageMeta
        self.dateAcceptation = dateAcceptation
        self.vehicule = vehicule
        self.scannedDocs = scannedDocs
        self.colisImages = colisImages
    }
}


extension Course {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Course.self, from: data)
        self.init(createdAt: me.createdAt, dateEnlevement: me.dateEnlevement, observationArrivee: me.observationArrivee, pointEnlevement: me.pointEnlevement, montantHT: me.montantHT, nombreColis: me.nombreColis, estimatedKM: me.estimatedKM, id: me.id, articleFamilies: me.articleFamilies, status: me.status, observation: me.observation, chauffeur: me.chauffeur, manutention: me.manutention, yusoRequestID: me.yusoRequestID, adresseArrivee: me.adresseArrivee, dateAffirmationFin: me.dateAffirmationFin, manutentionDouble: me.manutentionDouble, courseSource: me.courseSource, lettreDeVoiture: me.lettreDeVoiture, contactArrivee: me.contactArrivee, code: me.code, articles: me.articles, commande: me.commande, factures: me.factures, dateLivraison: me.dateLivraison, signaturesImages: me.signaturesImages, adresseDepart: me.adresseDepart, dateDemarrage: me.dateDemarrage, isStatusChangedManually: me.isStatusChangedManually, contactDepart: me.contactDepart, codeCorner: me.codeCorner, moyenPaiement: me.moyenPaiement, vehiculeType: me.vehiculeType, dateDemarrageMeta: me.dateDemarrageMeta, dateAcceptation: me.dateAcceptation, vehicule: me.vehicule, scannedDocs: me.scannedDocs, colisImages: me.colisImages)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        createdAt: String?? = nil,
        dateEnlevement: String?? = nil,
        observationArrivee: String?? = nil,
        pointEnlevement: String?? = nil,
        montantHT: Double?? = nil,
        nombreColis: Int?? = nil,
        estimatedKM: Double?? = nil,
        id: Int?? = nil,
        articleFamilies: [ArticleFamily]?? = nil,
        status: Status?? = nil,
        observation: String?? = nil,
        chauffeur: Chauffeur?? = nil,
        manutention: Bool?? = nil,
        yusoRequestID: String?? = nil,
        adresseArrivee: Adresse?? = nil,
        dateAffirmationFin: String?? = nil,
        manutentionDouble: Bool?? = nil,
        courseSource: String?? = nil,
        lettreDeVoiture: LettreDeVoiture?? = nil,
        contactArrivee: Contact?? = nil,
        code: String?? = nil,
        articles: [String]?? = nil,
        commande: Commande?? = nil,
        factures: String?? = nil,
        dateLivraison: String?? = nil,
        signaturesImages: [SignatureImage]?? = nil,
        adresseDepart: Adresse?? = nil,
        dateDemarrage: String?? = nil,
        isStatusChangedManually: Bool?? = nil,
        contactDepart: Contact?? = nil,
        codeCorner: String?? = nil,
        moyenPaiement: MoyenPaiement?? = nil,
        vehiculeType: String?? = nil,
        dateDemarrageMeta: DateDemarrageMeta?? = nil,
        dateAcceptation: String?? = nil,
        vehicule: Vehicule?? = nil,
        scannedDocs: [String]?? = nil,
        colisImages: [String]?? = nil
        ) -> Course {
        return Course(
            createdAt: createdAt ?? self.createdAt,
            dateEnlevement: dateEnlevement ?? self.dateEnlevement,
            observationArrivee: observationArrivee ?? self.observationArrivee,
            pointEnlevement: pointEnlevement ?? self.pointEnlevement,
            montantHT: montantHT ?? self.montantHT,
            nombreColis: nombreColis ?? self.nombreColis,
            estimatedKM: estimatedKM ?? self.estimatedKM,
            id: id ?? self.id,
            articleFamilies: articleFamilies ?? self.articleFamilies,
            status: status ?? self.status,
            observation: observation ?? self.observation,
            chauffeur: chauffeur ?? self.chauffeur,
            manutention: manutention ?? self.manutention,
            yusoRequestID: yusoRequestID ?? self.yusoRequestID,
            adresseArrivee: adresseArrivee ?? self.adresseArrivee,
            dateAffirmationFin: dateAffirmationFin ?? self.dateAffirmationFin,
            manutentionDouble: manutentionDouble ?? self.manutentionDouble,
            courseSource: courseSource ?? self.courseSource,
            lettreDeVoiture: lettreDeVoiture ?? self.lettreDeVoiture,
            contactArrivee: contactArrivee ?? self.contactArrivee,
            code: code ?? self.code,
            articles: articles ?? self.articles,
            commande: commande ?? self.commande,
            factures: factures ?? self.factures,
            dateLivraison: dateLivraison ?? self.dateLivraison,
            signaturesImages: signaturesImages ?? self.signaturesImages,
            adresseDepart: adresseDepart ?? self.adresseDepart,
            dateDemarrage: dateDemarrage ?? self.dateDemarrage,
            isStatusChangedManually: isStatusChangedManually ?? self.isStatusChangedManually,
            contactDepart: contactDepart ?? self.contactDepart,
            codeCorner: codeCorner ?? self.codeCorner,
            moyenPaiement: moyenPaiement ?? self.moyenPaiement,
            vehiculeType: vehiculeType ?? self.vehiculeType,
            dateDemarrageMeta: dateDemarrageMeta ?? self.dateDemarrageMeta,
            dateAcceptation: dateAcceptation ?? self.dateAcceptation,
            vehicule: vehicule ?? self.vehicule,
            scannedDocs: scannedDocs ?? self.scannedDocs,
            colisImages: colisImages ?? self.colisImages
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
