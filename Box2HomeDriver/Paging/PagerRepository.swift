//
//  PagerRepository.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/15/19.
//  Copyright © 2019 MacHD. All rights reserved.
//
import Foundation
import UIKit
struct PagerRepository {
    static let sharedInstance = PagerRepository()
    let CarImages: [UIImage] = [UIImage(named: "S")!,UIImage(named: "M")!,UIImage(named: "L")!]
    
    func DoCreateSlides() -> [Slide] {
        var slides:[Slide] = []
        let vehicules: [vehicule] = SessionManager.currentSession.chauffeur!.vehicules!
        for car in vehicules {
            let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide.imageView.image = CarImages[GetImageIntType(s: car.vehicule_category.type)]
            slide.nom.text = car.denomination
            slide.matricule.text = car.immatriculation
            slides.append(slide)
        }
     
        return slides
  }
    func DoSetupSlideScrollView(slides : [Slide], scrollView: UIScrollView, view: UIView) {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func GetImageIntType(s:String) -> Int {
        switch s {
        case "S":
            return 0
        case "M":
            return 1
        case "L":
            return 2
        default:
            return 3
        }
    }
}
