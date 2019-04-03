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
    
    let bottomView = UIView()
    
    let GoButton = UIButton(type: .system)
    let CancelButton = UIButton(type: .system)
    let ArrivedButton = UIButton(type: .system)
    
    var mapView = GMSMapView()
    var mapViewHeightConstraint: NSLayoutConstraint!
    var bottomViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleSideMenuView()
         SetupMapView()
         SetupBottomView()
    }
    fileprivate func SetupBottomView() {
        //**************BottomView**************
         view.addSubview(bottomView)
        bottomView.layer.shadowColor = UIColor(ciColor: .black).cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 1);
        bottomView.layer.shadowOpacity = 1;
        bottomView.layer.shadowRadius = 1.0;
        bottomView.clipsToBounds = false;
        bottomView.backgroundColor =  UIColor(displayP3Red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        //Layout Setup
        bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: view.frame.height * 3 / 10)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        bottomViewHeightConstraint.isActive = true
        //**************ArrivedButton**************
        bottomView.addSubview(ArrivedButton)
        ArrivedButton.setTitle("Arrivé", for: .normal)
        ArrivedButton.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        ArrivedButton.tintColor = .white
        ArrivedButton.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        ArrivedButton.layer.cornerRadius = 10
        //Action Setup
        ArrivedButton.addTarget(self, action: #selector(extendBottomView), for: .touchUpInside)
        //Layout Setup
        ArrivedButton.translatesAutoresizingMaskIntoConstraints = false
        ArrivedButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        ArrivedButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10).isActive = true
        ArrivedButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -110).isActive = true
        ArrivedButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //**************CancelButton**************
        bottomView.addSubview(CancelButton)
        CancelButton.setTitle("Annuler", for: .normal)
        CancelButton.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        CancelButton.tintColor = .white
        CancelButton.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        CancelButton.layer.cornerRadius = 10
        //Action Setup
        CancelButton.addTarget(self, action: #selector(dropDownBottomView), for: .touchUpInside)
        //Layout Setup
        CancelButton.translatesAutoresizingMaskIntoConstraints = false
        CancelButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        CancelButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10).isActive = true
        CancelButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -40).isActive = true
        CancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    fileprivate func SetupMapView() {
        //**************mapView**************
       
        let bounds =  GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: latitudeDepart, longitude: longitudeDepart), coordinate: CLLocationCoordinate2D(latitude: latitudeArrivee, longitude: longitudeArrivee))
        let update: GMSCameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
        //  let cameraWithPadding: GMSCameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100.0) (will put inset the bounding box from the view's edge)
//        self.mapView.animate(with: camera)
        
        let camera = GMSCameraPosition.camera(withLatitude: latitudeDepart, longitude: longitudeDepart, zoom: 6.0)
   
    
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 7 / 10)
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.mapView.animate(with: update)
                self.viewModel.drawPath(startLocation: CLLocation(latitude: self.latitudeDepart, longitude: self.longitudeDepart), endLocation: CLLocation(latitude: self.latitudeArrivee, longitude: self.longitudeArrivee), mapView: self.mapView)
        }
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        mapViewHeightConstraint = mapView.heightAnchor.constraint(equalToConstant: view.frame.height * 7 / 10)
//
//        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        mapViewHeightConstraint.isActive = true

        self.view.addSubview(mapView)

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

    @objc func extendBottomView(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 4 / 10
//            self.mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 6 / 10)
            self.view.layoutIfNeeded()
        })
    }
    @objc func dropDownBottomView(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 3 / 10
//            self.mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 7 / 10)
            self.view.layoutIfNeeded()
        })
    }
}
