//
//  SetupHomeView.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/5/19.
//  Copyright © 2019 MacHD. All rights reserved.
//


import UIKit
import NVActivityIndicatorView

class SetupHomeView: NSObject {

    static let sharedInstance : SetupHomeView = SetupHomeView()
    
    func SetupMenuButton(MenuButton: UIButton) {
        MenuButton.setImage(UIImage(named: "menuIcon"), for:.normal)
        MenuButton.setTitleColor(.white, for: .normal)
        MenuButton.imageView?.tintColor = .white
        MenuButton.imageView?.contentMode = .scaleAspectFit
    }
    func SetupMapButton(MapButton: UIButton) {
       
        MapButton.setImage(UIImage(named: "map"), for:.normal)
        MapButton.setTitleColor(.white, for: .selected)
        MapButton.imageView?.contentMode = .scaleAspectFit
        MapButton.imageView?.tintColor = .white
    }
    func SetupSeguementedControl(SeguementedControl: UISegmentedControl) {
        SeguementedControl.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        SeguementedControl.removeBorders()
        SeguementedControl.layer.shadowColor = UIColor(ciColor: .black).cgColor
        SeguementedControl.layer.shadowOffset = CGSize(width: 0, height: 1);
        SeguementedControl.layer.shadowOpacity = 1;
        SeguementedControl.layer.shadowRadius = 1.0;
        SeguementedControl.clipsToBounds = false;
        SeguementedControl.tintColor = UIColor.clear
        if (SessionManager.currentSession.acceptedCourses.count != 0){
        SeguementedControl.setTitle("EN COURS(\(SessionManager.currentSession.acceptedCourses.count))", forSegmentAt: 0)
        } else {SeguementedControl.setTitle("EN COURS", forSegmentAt: 0)}
        if (SessionManager.currentSession.assignedCourses.count != 0){
       SeguementedControl.setTitle("ATTRIBUÉES(\(SessionManager.currentSession.assignedCourses.count))", forSegmentAt: 1)
        }else {SeguementedControl.setTitle("ATTRIBUÉES", forSegmentAt: 1)}
    }
    func SetupBarView(BarView: UIView) {
        BarView.backgroundColor =  UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        BarView.layer.shadowColor = UIColor(ciColor: .black).cgColor
        BarView.layer.shadowOffset = CGSize(width: 0, height: 1);
        BarView.layer.shadowOpacity = 1;
        BarView.layer.shadowRadius = 1.0;
        BarView.clipsToBounds = false;
    }
    func SetupStatusImage(StatusImage: UIImageView,vc: UIViewController) {
        StatusImage.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        StatusImage.frame  = (vc.navigationController?.navigationBar.frame)!
    }
    override init() {
        super.init()
    }
}
