//
//  HomeViewModel.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/14/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

class HomeViewModel {
    private var HomeRepository: HomeRepository?
  
    
    init(HomeRepository : HomeRepository
        ) { self.HomeRepository = HomeRepository
    }
    
        
    var CoursesFetched: [Course]? = [] {
        didSet { self.CoursesFetchedClosure?() }
    }
    var ArrayDidChange: Int = SessionManager.currentSession.assignedCourses.count {
        didSet { self.ArrayDidChangeClosure?() }
    }
  
   
    var CoursesFetchedClosure: (() -> ())?
    var ArrayDidChangeClosure: (() -> ())?
    
  
    
    func fetchCourses(tag : String){
     self.CoursesFetched = (self.HomeRepository?.DoFetchCourses(tag: tag))!
}

}

