//
//  Course.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/26/19.
//  Copyright © 2019 MacHD. All rights reserved.


import Foundation
import RealmSwift
import Realm

@objcMembers 
class Course: Object, Codable {
    dynamic var createdAt: String? = nil
    dynamic var dateEnlevement: String? = nil
    dynamic var observationArrivee: String? = nil
    dynamic var pointEnlevement: String? = nil
    let montantHT = RealmOptional<Double>()
    let nombreColis = RealmOptional<Int>()
    let estimatedKM = RealmOptional<Double>()
    let id = RealmOptional<Int>()
    var articleFamilies = RealmSwift.List<ArticleFamily>()
    dynamic var status: Status?
    dynamic var observation: String? = nil
    dynamic var chauffeur: Chauffeur?
    let manutention = RealmOptional<Bool>()
    dynamic var yusoRequestID: String? = nil
    dynamic var adresseArrivee: Adresse?
    dynamic var dateAffirmationFin: String? = nil
    let manutentionDouble = RealmOptional<Bool>()
    dynamic var courseSource: String? = nil
    dynamic var lettreDeVoiture: LettreDeVoiture?
    dynamic var contactArrivee: Contact?
    dynamic var code: String? = nil
    var articles = RealmSwift.List<Article>()
    dynamic var commande: Commande?
    dynamic var factures: String? = nil
    dynamic var dateLivraison: String? = nil
    var signaturesImages = RealmSwift.List<SignatureImage>()
    dynamic var adresseDepart: Adresse?
    dynamic var dateDemarrage: String? = nil
    let isStatusChangedManually = RealmOptional<Bool>()
    dynamic var contactDepart: Contact?
    dynamic var codeCorner: String? = nil
    dynamic var moyenPaiement: MoyenPaiement?
    dynamic var vehiculeType: String? = nil
    dynamic var dateDemarrageMeta: DateDemarrageMeta?
    dynamic var dateAcceptation: String? = nil
    dynamic var vehicule: Vehicule?
    dynamic var signatureDepartData: Data? = nil
    dynamic var signatureArriveeData: Data? = nil
    var scannedDocs = RealmSwift.List<ScannedDoc>()
    var colisImages = RealmSwift.List<String>()
    var colisImagesDataDepart = RealmSwift.List<Data>()
    var colisImagesDataArrivee = RealmSwift.List<Data>()
    
    enum CodingKeys: String, CodingKey {
        case createdAt, dateEnlevement, observationArrivee, pointEnlevement, montantHT, nombreColis, estimatedKM, id, articleFamilies, status, observation, chauffeur, manutention,adresseArrivee, dateAffirmationFin, manutentionDouble, courseSource, lettreDeVoiture, contactArrivee, code, articles, commande, factures, dateLivraison, signaturesImages, adresseDepart, dateDemarrage, isStatusChangedManually, contactDepart, codeCorner, moyenPaiement, vehiculeType, dateDemarrageMeta, dateAcceptation, vehicule, scannedDocs, colisImages, colisImagesDataDepart, colisImagesDataArrivee, signatureDepartData, signatureArriveeData
        case yusoRequestID = "YusoRequestID"
        
    }
    

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? nil
        dateEnlevement = try container.decodeIfPresent(String.self, forKey: .dateEnlevement) ?? nil
        observationArrivee = try container.decodeIfPresent(String.self, forKey: .observationArrivee) ?? nil
        pointEnlevement = try container.decodeIfPresent(String.self, forKey: .pointEnlevement) ?? nil
        self.montantHT.value = try container.decodeIfPresent(Double.self, forKey:.montantHT) ?? nil
        self.nombreColis.value = try container.decodeIfPresent(Int.self, forKey:.nombreColis) ?? nil
        self.estimatedKM.value = try container.decodeIfPresent(Double.self, forKey:.estimatedKM) ?? nil
        self.id.value = try container.decodeIfPresent(Int.self, forKey:.id) ?? nil
        status = try container.decodeIfPresent(Status.self, forKey: .status) ?? nil
        observation = try container.decodeIfPresent(String.self, forKey: .observation) ?? nil
        chauffeur = try container.decodeIfPresent(Chauffeur.self, forKey: .chauffeur) ?? nil
        self.manutention.value = try container.decodeIfPresent(Bool.self, forKey:.manutention) ?? nil
        self.manutentionDouble.value = try container.decodeIfPresent(Bool.self, forKey:.manutentionDouble) ?? nil
        self.isStatusChangedManually.value = try container.decodeIfPresent(Bool.self, forKey:.isStatusChangedManually) ?? nil
        yusoRequestID = try container.decodeIfPresent(String.self, forKey: .yusoRequestID) ?? nil
        adresseArrivee = try container.decodeIfPresent(Adresse.self, forKey: .adresseArrivee) ?? nil
        dateAffirmationFin = try container.decodeIfPresent(String.self, forKey: .dateAffirmationFin) ?? nil
        courseSource = try container.decodeIfPresent(String.self, forKey: .courseSource) ?? nil
        lettreDeVoiture = try container.decodeIfPresent(LettreDeVoiture.self, forKey: .lettreDeVoiture) ?? nil
        contactArrivee = try container.decodeIfPresent(Contact.self, forKey: .contactArrivee) ?? nil
        code = try container.decodeIfPresent(String.self, forKey: .code) ?? nil
        commande = try container.decodeIfPresent(Commande.self, forKey: .commande) ?? nil
        factures = try container.decodeIfPresent(String.self, forKey: .factures) ?? nil
        dateLivraison = try container.decodeIfPresent(String.self, forKey: .dateLivraison) ?? nil
        adresseDepart = try container.decodeIfPresent(Adresse.self, forKey: .adresseDepart) ?? nil
        dateDemarrage = try container.decodeIfPresent(String.self, forKey: .dateDemarrage) ?? nil
        contactDepart = try container.decodeIfPresent(Contact.self, forKey: .contactDepart) ?? nil
        codeCorner = try container.decodeIfPresent(String.self, forKey: .codeCorner) ?? nil
        moyenPaiement = try container.decodeIfPresent(MoyenPaiement.self, forKey: .moyenPaiement) ?? nil
        vehiculeType = try container.decodeIfPresent(String.self, forKey: .vehiculeType) ?? nil
        dateDemarrageMeta = try container.decodeIfPresent(DateDemarrageMeta.self, forKey: .dateDemarrageMeta) ?? nil
        dateAcceptation = try container.decodeIfPresent(String.self, forKey: .dateAcceptation) ?? nil
        vehicule = try container.decodeIfPresent(Vehicule.self, forKey: .vehicule) ?? nil
        articleFamilies = try container.decodeIfPresent(List<ArticleFamily>.self,forKey: .articleFamilies) ?? List<ArticleFamily>()
        signaturesImages = try container.decodeIfPresent(List<SignatureImage>.self,forKey: .signaturesImages) ?? List<SignatureImage>()
        scannedDocs = try container.decodeIfPresent(List<ScannedDoc>.self,forKey: .scannedDocs) ?? List<ScannedDoc>()
        colisImages = try container.decodeIfPresent(List<String>.self,forKey: .colisImages) ?? List<String>()
        colisImagesDataDepart = try container.decodeIfPresent(List<Data>.self,forKey: .colisImagesDataDepart) ?? List<Data>()
        colisImagesDataArrivee = try container.decodeIfPresent(List<Data>.self,forKey: .colisImagesDataArrivee) ?? List<Data>()
        articles = try container.decodeIfPresent(List<Article>.self,forKey: .articles) ?? List<Article>()
        signatureDepartData = try container.decodeIfPresent(Data.self,forKey: .signatureDepartData) ?? Data()
        signatureArriveeData = try container.decodeIfPresent(Data.self,forKey: .signatureArriveeData) ?? Data()
        super.init()
    }
    required init(createdAt: String?, dateEnlevement: String?, observationArrivee: String?, pointEnlevement: String?, montantHT: Double?, nombreColis: Int?, estimatedKM: Double?, id: Int?, articleFamilies: List<ArticleFamily>, status: Status?, observation: String?, chauffeur: Chauffeur?, manutention: Bool?, yusoRequestID: String?, adresseArrivee: Adresse?, dateAffirmationFin: String?, manutentionDouble: Bool?, courseSource: String?, lettreDeVoiture: LettreDeVoiture?, contactArrivee: Contact?, code: String?, articles: List<Article>, commande: Commande?, factures: String?, dateLivraison: String?, signaturesImages: List<SignatureImage>, adresseDepart: Adresse?, dateDemarrage: String?, isStatusChangedManually: Bool?, contactDepart: Contact?, codeCorner: String?, moyenPaiement: MoyenPaiement?, vehiculeType: String?, dateDemarrageMeta: DateDemarrageMeta?, dateAcceptation: String?, vehicule: Vehicule?, scannedDocs: List<ScannedDoc>, colisImages: List<String>,colisImagesDataDepart: List<Data>, colisImagesDataArrivee: List<Data>, signatureDepartData: Data?, signatureArriveeData: Data?) {
        self.createdAt = createdAt
        self.dateEnlevement = dateEnlevement
        self.observationArrivee = observationArrivee
        self.pointEnlevement = pointEnlevement
        self.montantHT.value = montantHT
        self.nombreColis.value = nombreColis
        self.estimatedKM.value = estimatedKM
        self.id.value = id
        self.articleFamilies = articleFamilies
        self.status = status
        self.observation = observation
        self.chauffeur = chauffeur
        self.manutention.value = manutention
        self.yusoRequestID = yusoRequestID
        self.adresseArrivee = adresseArrivee
        self.dateAffirmationFin = dateAffirmationFin
        self.manutentionDouble.value = manutentionDouble
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
        self.isStatusChangedManually.value = isStatusChangedManually
        self.contactDepart = contactDepart
        self.codeCorner = codeCorner
        self.moyenPaiement = moyenPaiement
        self.vehiculeType = vehiculeType
        self.dateDemarrageMeta = dateDemarrageMeta
        self.dateAcceptation = dateAcceptation
        self.vehicule = vehicule
        self.scannedDocs = scannedDocs
        self.colisImages = colisImages
        self.colisImagesDataDepart = colisImagesDataDepart
        self.colisImagesDataArrivee = colisImagesDataArrivee
        self.signatureDepartData = signatureDepartData
        self.signatureArriveeData = signatureArriveeData

        super.init()
    }
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    override static func primaryKey() -> String? {
        return "code"
    }
}


extension Course {
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.createdAt, forKey: .createdAt)
//        try container.encode(self.dateEnlevement, forKey: .dateEnlevement)
//        try container.encode(self.observationArrivee, forKey: .observationArrivee)
//        try container.encode(self.pointEnlevement, forKey: .pointEnlevement)
//        try container.encode(self.montantHT, forKey: .montantHT)
//        try container.encode(self.nombreColis, forKey: .nombreColis)
//        try container.encode(self.estimatedKM, forKey: .estimatedKM)
//        try container.encode(self.id, forKey: .id)
//        try container.encode(self.status, forKey: .status)
//        try container.encode(self.observation, forKey: .observation)
//        try container.encode(self.chauffeur, forKey: .chauffeur)
//        try container.encode(self.manutention, forKey: .manutention)
//        try container.encode(self.yusoRequestID, forKey: .yusoRequestID)
//        try container.encode(self.adresseArrivee, forKey: .adresseArrivee)
//        try container.encode(self.dateAffirmationFin, forKey: .dateAffirmationFin)
//        try container.encode(self.manutentionDouble, forKey: .manutentionDouble)
//        try container.encode(self.courseSource, forKey: .courseSource)
//        try container.encode(self.lettreDeVoiture, forKey: .lettreDeVoiture)
//        try container.encode(self.contactArrivee, forKey: .contactArrivee)
//        try container.encode(self.code, forKey: .code)
//        try container.encode(self.commande, forKey: .commande)
//        try container.encode(self.factures, forKey: .factures)
//        try container.encode(self.dateLivraison, forKey: .dateLivraison)
//        try container.encode(self.adresseDepart, forKey: .adresseDepart)
//        try container.encode(self.dateDemarrage, forKey: .dateDemarrage)
//        try container.encode(self.isStatusChangedManually, forKey: .isStatusChangedManually)
//        try container.encode(self.contactDepart, forKey: .contactDepart)
//        try container.encode(self.codeCorner, forKey: .codeCorner)
//        try container.encode(self.moyenPaiement, forKey: .moyenPaiement)
//        try container.encode(self.vehiculeType, forKey: .vehiculeType)
//        try container.encode(self.dateDemarrageMeta, forKey: .dateDemarrageMeta)
//        try container.encode(self.dateAcceptation, forKey: .dateAcceptation)
//        try container.encode(self.vehicule, forKey: .vehicule)
//        let articleFamiliesArray = Array(self.articleFamilies)
//        try container.encode(articleFamiliesArray, forKey: .articleFamilies)
//        let signaturesImagesArray = Array(self.signaturesImages)
//        try container.encode(signaturesImagesArray, forKey: .signaturesImages)
//        let scannedDocsArray = Array(self.scannedDocs)
//        try container.encode(scannedDocsArray, forKey: .scannedDocs)
//        let colisImagesArray = Array(self.colisImages)
//        try container.encode(colisImagesArray, forKey: .colisImages)
//        let articlesArray = Array(self.articles)
//        try container.encode(articlesArray, forKey: .articles)
//    }
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Course.self, from: data)
        self.init(createdAt: me.createdAt, dateEnlevement: me.dateEnlevement, observationArrivee: me.observationArrivee, pointEnlevement: me.pointEnlevement, montantHT: me.montantHT.value, nombreColis: me.nombreColis.value, estimatedKM: me.estimatedKM.value, id: me.id.value, articleFamilies: me.articleFamilies, status: me.status, observation: me.observation, chauffeur: me.chauffeur, manutention: me.manutention.value, yusoRequestID: me.yusoRequestID, adresseArrivee: me.adresseArrivee, dateAffirmationFin: me.dateAffirmationFin, manutentionDouble: me.manutentionDouble.value, courseSource: me.courseSource, lettreDeVoiture: me.lettreDeVoiture, contactArrivee: me.contactArrivee, code: me.code, articles: me.articles, commande: me.commande, factures: me.factures, dateLivraison: me.dateLivraison, signaturesImages: me.signaturesImages, adresseDepart: me.adresseDepart, dateDemarrage: me.dateDemarrage, isStatusChangedManually: me.isStatusChangedManually.value, contactDepart: me.contactDepart, codeCorner: me.codeCorner, moyenPaiement: me.moyenPaiement, vehiculeType: me.vehiculeType, dateDemarrageMeta: me.dateDemarrageMeta, dateAcceptation: me.dateAcceptation, vehicule: me.vehicule, scannedDocs: me.scannedDocs, colisImages: me.colisImages,colisImagesDataDepart: me.colisImagesDataDepart, colisImagesDataArrivee: me.colisImagesDataArrivee, signatureDepartData: me.signatureDepartData, signatureArriveeData: me.signatureArriveeData)
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
        articleFamilies: List<ArticleFamily>? = nil,
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
        articles: List<Article>? = nil,
        commande: Commande?? = nil,
        factures: String?? = nil,
        dateLivraison: String?? = nil,
        signaturesImages: List<SignatureImage>? = nil,
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
        scannedDocs: List<ScannedDoc>? = nil,
        colisImages: List<String>? = nil,
        colisImagesDataDepart: List<Data>? = nil,
        colisImagesDataArrivee: List<Data>? = nil,
        signatureDepartData: Data? = nil,
        signatureArriveeData: Data? = nil
        ) -> Course {
        return Course(
            createdAt: createdAt ?? self.createdAt,
            dateEnlevement: dateEnlevement ?? self.dateEnlevement,
            observationArrivee: observationArrivee ?? self.observationArrivee,
            pointEnlevement: pointEnlevement ?? self.pointEnlevement,
            montantHT: montantHT ?? self.montantHT.value,
            nombreColis: nombreColis ?? self.nombreColis.value,
            estimatedKM: estimatedKM ?? self.estimatedKM.value,
            id: id ?? self.id.value,
            articleFamilies: articleFamilies ?? self.articleFamilies,
            status: status ?? self.status,
            observation: observation ?? self.observation,
            chauffeur: chauffeur ?? self.chauffeur,
            manutention: manutention ?? self.manutention.value,
            yusoRequestID: yusoRequestID ?? self.yusoRequestID,
            adresseArrivee: adresseArrivee ?? self.adresseArrivee,
            dateAffirmationFin: dateAffirmationFin ?? self.dateAffirmationFin,
            manutentionDouble: manutentionDouble ?? self.manutentionDouble.value,
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
            isStatusChangedManually: isStatusChangedManually ?? self.isStatusChangedManually.value,
            contactDepart: contactDepart ?? self.contactDepart,
            codeCorner: codeCorner ?? self.codeCorner,
            moyenPaiement: moyenPaiement ?? self.moyenPaiement,
            vehiculeType: vehiculeType ?? self.vehiculeType,
            dateDemarrageMeta: dateDemarrageMeta ?? self.dateDemarrageMeta,
            dateAcceptation: dateAcceptation ?? self.dateAcceptation,
            vehicule: vehicule ?? self.vehicule,
            scannedDocs: scannedDocs ?? self.scannedDocs,
            colisImages: colisImages ?? self.colisImages,
            colisImagesDataDepart: colisImagesDataDepart ?? self.colisImagesDataDepart,
            colisImagesDataArrivee: colisImagesDataArrivee ?? self.colisImagesDataArrivee,
            signatureDepartData: signatureDepartData ?? self.signatureDepartData,
            signatureArriveeData: signatureArriveeData ?? self.signatureArriveeData
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


