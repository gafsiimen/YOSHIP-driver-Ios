//
//  CourseDetailsController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/2/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import GoogleMaps

class CourseDetailsController: UIViewController {
    let viewModel = CourseDetailViewModel(CourseDetailRepository: CourseDetailRepository())

    var CourseTag:String = ""
    var latitudeDepart:Double = 0
    var longitudeDepart:Double = 0
    var latitudeArrivee:Double = 0
    var longitudeArrivee:Double = 0
    var adresseDepart: String = ""
    var adresseArrivee: String = ""
    var LabelText: String = ""
    
    let bottomView: UIView = {
        let bv = UIView()
        bv.layer.shadowColor = UIColor(ciColor: .black).cgColor
        bv.layer.shadowOffset = CGSize(width: 0, height: 1);
        bv.layer.shadowOpacity = 1;
        bv.layer.shadowRadius = 1.0;
        bv.clipsToBounds = false;
        bv.backgroundColor =  UIColor(displayP3Red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        return bv
    }()
    //---------------------------------------------------------------------
    lazy var stackViewAssigned: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [GoButton, BackButton1])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    let GoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (0/255), green: 204/255, blue: 0/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goButton), for: .touchUpInside)
        return button
    }()
    let BackButton1 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    //---------------------------------------------------------------------
    lazy var stackViewAccepted: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewArrivedOrCancel, BackButton2])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewArrivedOrCancel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ArrivedButton, CancelButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let ArrivedButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Arrivé", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (0/255), green: 204/255, blue: 0/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(arrivedButton), for: .touchUpInside)
        return button
    }()
    let CancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Annuler", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cancelButton), for: .touchUpInside)
        return button
    }()
    let BackButton2 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    //---------------------------------------------------------------------
    lazy var stackViewOuiNonBack_Arrived: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_Arrived, BackButton3])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewOuiNon_Arrived: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [OuiButton_Arrived, NonButton_Arrived])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let OuiButton_Arrived : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (0/255), green: 204/255, blue: 0/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(ouiButton_Arrived), for: .touchUpInside)
        return button
    }()
    let NonButton_Arrived : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nonButton_Arrived), for: .touchUpInside)
        return button
    }()
    let BackButton3 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    //---------------------------------------------------------------------
    lazy var stackViewOuiNonBack_Go: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_Go, BackButton4])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewOuiNon_Go: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [OuiButton_Go, NonButton_Go])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let OuiButton_Go : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (0/255), green: 204/255, blue: 0/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(ouiButton_Go), for: .touchUpInside)
        return button
    }()
    let NonButton_Go : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nonButton_Go), for: .touchUpInside)
        return button
    }()
    let BackButton4 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    //---------------------------------------------------------------------
    lazy var stackViewOuiNonBack_Cancel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_Cancel, BackButton5])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewOuiNon_Cancel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [OuiButton_Cancel, NonButton_Cancel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let OuiButton_Cancel : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (0/255), green: 204/255, blue: 0/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(ouiButton_Cancel), for: .touchUpInside)
        return button
    }()
    let NonButton_Cancel : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nonButton_Cancel), for: .touchUpInside)
        return button
    }()
    let BackButton5 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    //---------------------------------------------------------------------
    @objc func arrivedButton(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 4 / 10
            self.view.layoutIfNeeded()
        })
        stackViewAccepted.alpha = 0
        stackViewOuiNonBack_Arrived.alpha = 1
    }
    @objc func cancelButton(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 4 / 10
            self.view.layoutIfNeeded()
        })
        stackViewAccepted.alpha = 0
        stackViewOuiNonBack_Cancel.alpha = 1
    }
    @objc func goButton(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 3 / 10
            self.stackViewAssigned.alpha = 0
            self.stackViewOuiNonBack_Go.alpha = 1
            self.view.layoutIfNeeded()
        })
       
    }
   
    @objc func ouiButton_Arrived(){
       print("OUI ARRIVED")
    }
    @objc func nonButton_Arrived(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 2 / 10
            self.view.layoutIfNeeded()
        })
        stackViewAccepted.alpha = 1
        stackViewOuiNonBack_Arrived.alpha = 0
    }
    @objc func ouiButton_Cancel(){
        print("OUI CANCEL")
    }
    @objc func nonButton_Cancel(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 2 / 10
            self.view.layoutIfNeeded()
        })
        stackViewAccepted.alpha = 1
        stackViewOuiNonBack_Cancel.alpha = 0
    }
    @objc func ouiButton_Go(){
       print("OUI GO")
    }
    @objc func nonButton_Go(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 2 / 10
            self.view.layoutIfNeeded()
        })
        stackViewAssigned.alpha = 1
        stackViewOuiNonBack_Go.alpha = 0
    }
    @objc func goBackButton(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        destViewController.toggleSideMenuView()
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
   //---------------------------------------------------------------------
    var mapView = GMSMapView()
    var mapViewHeightConstraint: NSLayoutConstraint!
    var bottomViewHeightConstraint: NSLayoutConstraint!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupView()
    }
    
    fileprivate func SetupView() {
        SetupMapView()
        SetupBottomView()
    }
    fileprivate func SetupBottomView() {
        //**************BottomView**************
         view.addSubview(bottomView)
        //Layout Setup
        bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: view.frame.height * 2 / 10)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        bottomViewHeightConstraint.isActive = true
      
      //----------Init--------------
        if CourseTag == "assigned"{
            stackViewAssigned.alpha = 1
            stackViewAccepted.alpha = 0
        } else {
            stackViewAssigned.alpha = 0
            stackViewAccepted.alpha = 1
        }
    //----------------------------------
        //**************stackViewAccepted**************
        bottomView.addSubview(stackViewAccepted)
        //Layout Setup stackViewAccepted
        stackViewAccepted.translatesAutoresizingMaskIntoConstraints = false
        stackViewAccepted.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
        stackViewAccepted.heightAnchor.constraint(equalToConstant: bottomViewHeightConstraint.constant - 50).isActive = true
        stackViewAccepted.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackViewAccepted.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //**************stackViewAccepted**************
        bottomView.addSubview(stackViewAssigned)
        //Layout Setup stackViewAssigned
        stackViewAssigned.translatesAutoresizingMaskIntoConstraints = false
        stackViewAssigned.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
        stackViewAssigned.heightAnchor.constraint(equalToConstant: bottomViewHeightConstraint.constant - 50).isActive = true
        stackViewAssigned.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackViewAssigned.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //**************stackViewOuiNonBack_Arrived**************
        bottomView.addSubview(stackViewOuiNonBack_Arrived)
        stackViewOuiNonBack_Arrived.alpha = 0
        //Layout Setup
        stackViewOuiNonBack_Arrived.translatesAutoresizingMaskIntoConstraints = false
        stackViewOuiNonBack_Arrived.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
        stackViewOuiNonBack_Arrived.heightAnchor.constraint(equalToConstant: bottomViewHeightConstraint.constant - 50).isActive = true
        stackViewOuiNonBack_Arrived.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackViewOuiNonBack_Arrived.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //**************stackViewOuiNonBack_Go**************
        bottomView.addSubview(stackViewOuiNonBack_Go)
        stackViewOuiNonBack_Go.alpha = 0
        //Layout Setup
        stackViewOuiNonBack_Go.translatesAutoresizingMaskIntoConstraints = false
        stackViewOuiNonBack_Go.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
        stackViewOuiNonBack_Go.heightAnchor.constraint(equalToConstant: bottomViewHeightConstraint.constant - 50).isActive = true
        stackViewOuiNonBack_Go.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackViewOuiNonBack_Go.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //**************stackViewOuiNonBack_Cancel**************
        bottomView.addSubview(stackViewOuiNonBack_Cancel)
        stackViewOuiNonBack_Cancel.alpha = 0
        //Layout Setup
        stackViewOuiNonBack_Cancel.translatesAutoresizingMaskIntoConstraints = false
        stackViewOuiNonBack_Cancel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
        stackViewOuiNonBack_Cancel.heightAnchor.constraint(equalToConstant: bottomViewHeightConstraint.constant - 50).isActive = true
        stackViewOuiNonBack_Cancel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackViewOuiNonBack_Cancel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    fileprivate func SetupMapView() {
        //**************mapView**************
        let bounds =  GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: latitudeDepart, longitude: longitudeDepart), coordinate: CLLocationCoordinate2D(latitude: latitudeArrivee, longitude: longitudeArrivee))
        let update: GMSCameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
        let camera = GMSCameraPosition.camera(withLatitude: latitudeDepart, longitude: longitudeDepart, zoom: 6.0)
   
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 8 / 10)
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.mapView.animate(with: update)
                self.viewModel.drawPath(startLocation: CLLocation(latitude: self.latitudeDepart, longitude: self.longitudeDepart), endLocation: CLLocation(latitude: self.latitudeArrivee, longitude: self.longitudeArrivee), mapView: self.mapView)
        }
        self.view.addSubview(mapView)
        //**************Markers**************
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: latitudeDepart, longitude: longitudeDepart)
        marker1.title = "Départ"
        marker1.snippet = adresseDepart
        marker1.map = mapView
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: latitudeArrivee, longitude: longitudeArrivee)
        marker2.title = "Arrivée"
        marker2.snippet = adresseArrivee
        marker2.map = mapView
    }


}
