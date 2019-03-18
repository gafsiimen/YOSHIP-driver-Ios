//
//  MapViewController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/25/19.
//  Copyright © 2019 MacHD. All rights reserved.
// 

import UIKit
import GoogleMaps
import NVActivityIndicatorView

class MapViewController: UIViewController {
// ---------------------------------------------------
var LeftSafeDrag = UIView()

// ---------------------------------------------------
    @IBOutlet weak var StatusImage: UIImageView!
    @IBOutlet weak var BarView: UIView!
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var CancelMapButton: UIButton!
    
// ---------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        // ---------------------------------------------------
         StatusImage.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
         StatusImage.frame  = (self.navigationController?.navigationBar.frame)!
        // ---------------------------------------------------
        BarView.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        BarView.layer.shadowColor = UIColor(ciColor: .black).cgColor
        BarView.layer.shadowOffset = CGSize(width: 0, height: 1);
        BarView.layer.shadowOpacity = 1;
        BarView.layer.shadowRadius = 1.0;
        BarView.clipsToBounds = false;
        // ---------------------------------------------------
        MenuButton.setImage(UIImage(named: "menuIcon"), for:.normal)
        MenuButton.setTitleColor(.white, for: .normal)
        MenuButton.imageView?.tintColor = .white
        // ---------------------------------------------------
        CancelMapButton.setImage(UIImage(named: "list"), for:.normal)
        CancelMapButton.setTitleColor(.white, for: .normal)
        CancelMapButton.imageView?.tintColor = .white
        // ---------------------------------------------------
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.frame = view.frame
        // ---------------------------------------------------
        LeftSafeDrag.frame = CGRect(x: 0, y: 0, width: 15, height: view.frame.height)
        LeftSafeDrag.backgroundColor = UIColor.clear
        // ---------------------------------------------------
        view.addSubview(mapView)
        view.bringSubviewToFront(StatusImage)
        view.bringSubviewToFront(BarView)
        view.addSubview(LeftSafeDrag)
        // ---------------------------------------------------
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        // ---------------------------------------------------
    }


    @IBAction func MenuButton(_ sender: Any) {
         toggleSideMenuView()
    }
    
    @IBAction func CancelMapButton(_ sender: Any) {
        toggleSideMenuView()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
    
 }
