//
//  PagerViewModel.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/15/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit

class PagerViewModel {
    private var pagerRepository: PagerRepository?
    init(PagerRepository : PagerRepository ) {
        self.pagerRepository = PagerRepository
        }
    func CreateSlides() -> [Slide]{
        return (self.pagerRepository?.DoCreateSlides())!
    }
    func SetupSlideScrollView(slides : [Slide], scrollView: UIScrollView, view: UIView){
      self.pagerRepository?.DoSetupSlideScrollView(slides: slides, scrollView: scrollView, view: view)
    }
}
