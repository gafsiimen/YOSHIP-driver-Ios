
//
//  RealmManager.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/25/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    static let sharedInstance = RealmManager()
    private init(){
    }
    
    let realm = try! Realm()
//-------------
    func CourseIfExists (primaryKey: String) -> Course? {
        return realm.object(ofType: Course.self, forPrimaryKey: primaryKey)
//        return realm.object(ofType: Course.self, forPrimaryKey: primaryKey) != nil
    }
//-------------
//    func EndCourse(primaryKey : String) {
//        do {
//            if let course = realm.object(ofType: Course.self, forPrimaryKey: primaryKey){
//                try realm.write {
//                    realm.delete(course)
//               }
//            }
//        } catch {
//            print(error)
//            post(error)
//        }
//    }
    
    //-------------
    func setSignatureArrivee(_ course: Course,imageURL: String) {
        do {
            try realm.write {
                course.signaturesImages[1] = SignatureImage(type: "ARRIVEE", url: imageURL)
                realm.add(course,update: true)
            }
        } catch {
            print(error)
            post(error)
        }
    }
    //-------------
    func setSignatureDepart(_ course: Course,imageURL: String) {
        do {
            try realm.write {
                course.signaturesImages[0] = SignatureImage(type: "depart", url: imageURL)
                realm.add(course,update: true)
            }
        } catch {
            print(error)
            post(error)
        }
    }
//-------------
    func setPointEnlevementCourse(_ course: Course,type: String) {
        do {
            try realm.write {
                course.pointEnlevement = type
                realm.add(course,update: true)
            }
        } catch {
            print(error)
            post(error)
        }
    }
    //-------------
    func EndCourse(_ course: Course) {
        do {
            try realm.write {
                course.status!.label = "Terminée"
                course.status!.code = "END"
                realm.add(course,update: true)
            }
        } catch {
            print(error)
            post(error)
        }
    }
//-------------
    func deposingCourse(_ course: Course) {
        do {
            try realm.write {
                course.status!.label = "Déchargement"
                course.status!.code = "DECHARGEMENT"
                realm.add(course,update: true)
            }
        } catch {
            print(error)
            post(error)
        }
    }
    //-------------
    func deliveringCourse(_ course: Course) {
        do {
            try realm.write {
                course.status!.label = "Livraison"
                course.status!.code = "LIVRAISON"
                realm.add(course,update: true)
            }
        } catch {
            print(error)
            post(error)
        }
    }
    //-------------
    func pickupCourse(_ course: Course) {
        do {
            try realm.write {
                course.status!.label = "Enlèvement"
                course.status!.code = "ENLEVEMENT"
                realm.add(course,update: true)
            }
        } catch {
            print(error)
            post(error)
        }
    }
//-------------
    func acceptCourse(_ course: Course) {
        do {
            try realm.write {
                course.status!.label = "Acceptée"
                course.status!.code = "ACCEPTEE"
                realm.add(course,update: true)
            }
        } catch {
            print(error)
            post(error)
        }
    }
//-------------
    func createOrUpdateCourse(_ course: Course) {
        do {
            try realm.write {
                realm.add(course,update: true)
            }
        } catch {
            post(error)
        }
    }
//-------------
    func fetchCourses() -> Results<Course>{
        let CoursesResults = realm.objects(Course.self)
            return CoursesResults
    }
//-------------
    func deleteCourse(courseID: Int){
        do {
            guard let course = realm.object(ofType: Course.self, forPrimaryKey: courseID) else { return  }
            try realm.write {
                realm.delete(course)
            }
        } catch {
            post(error)
        }
    }
//-------------
    func fetchResponse() -> Results<Response> {
            let responseResult = realm.objects(Response.self)
            return responseResult
    }
//-------------
    func persistResponse(_ response: Response
//        , completion : (()->())?
        ){
        self.deleteResponse()
        do {
            try realm.write {
                realm.add(response)
            }
//        completion?()
        } catch {
            print(error)
            post(error)
        }
    }
//-------------
    func deleteResponse(){
        do {
            let response = realm.objects(Response.self)
            try realm.write {
                realm.delete(response)
            }
        } catch {
            print(error)
            post(error)
        }
    }
    
    
    
    
    
    func post(_ error : Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void)  {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"),
                                               object: nil,
                                               queue: nil) { (notification) in
                                                completion(notification.object as? Error)
        }
    }
    func stopObservingErrors(in vc : UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
    
    
}

extension RealmOptional : Encodable where Value: Encodable  {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let v = self.value {
            try v.encode(to: encoder)
        } else {
            try container.encodeNil()
        }
    }
}

extension RealmOptional : Decodable where Value: Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            self.value = try Value(from: decoder)
        }
    }
}
extension List : Decodable where Element : Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let element = try container.decode(Element.self)
            self.append(element)
        }
    }
}

extension List : Encodable where Element : Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try element.encode(to: container.superEncoder())
        }
    }
}
