//
//  HomeRepository.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/14/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
struct HomeRepository {
    static let sharedInstance = HomeRepository()
    
    func DoFetchCourses(tag:String) -> [Course] {
        var fetchedCourses : [Course] = []
        switch tag {
        case "accepted":
            fetchedCourses = SessionManager.currentSession.acceptedCourses
        case "assigned":
            fetchedCourses = SessionManager.currentSession.assignedCourses
        default:
            break
        }
        return fetchedCourses
        }
}
