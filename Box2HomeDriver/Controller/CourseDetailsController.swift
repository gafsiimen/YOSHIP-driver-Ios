//
//  CourseDetailsController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/2/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import GoogleMaps
import UberSignature

class CourseDetailsController: UIViewController, SignatureDrawingViewControllerDelegate, ENSideMenuDelegate {
    let viewModel = CourseDetailViewModel(CourseDetailRepository: CourseDetailRepository())
    private let signatureViewController = SignatureDrawingViewController()
    //---------
    var mapView = GMSMapView()
    var mapViewHeightConstraint: NSLayoutConstraint!
    var bottomViewHeightConstraint: NSLayoutConstraint!
    //---------
    var CourseTag:String = ""
    var latitudeDepart:Double = 0
    var longitudeDepart:Double = 0
    var latitudeArrivee:Double = 0
    var longitudeArrivee:Double = 0
    var adresseDepart: String = ""
    var adresseArrivee: String = ""
    var LabelText: String = ""
    var selectedType = 1
    //---------
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
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
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
//        button.setTitle("Oui", for: .normal)
       
        button.setImage(UIImage(named: "oui"), for:.normal)
        button.setTitleColor(.white, for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.alpha = 0.5
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(ouiButton_Arrived), for: .touchUpInside)
        return button
    }()
    let NonButton_Arrived : UIButton = {
        let button = UIButton(type: .system)
//        button.setTitle("Non", for: .normal)
        button.setImage(UIImage(named: "non"), for:.normal)
        button.setTitleColor(.white, for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        
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
    let signatureClient : UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.backgroundColor = .clear
        label.text = "Signature client"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        return label
    }()
     //---------------------------------------------------------------------
    lazy var stackViewType: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [Habitat, Magasin, Bureau])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let Habitat : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Habitat", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(11))!
        button.layer.cornerRadius = 5
        button.tag = 1
        button.addTarget(self, action: #selector(typePickButton(sender:)), for: .touchUpInside)
        return button
    }()
    let Magasin : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Magasin", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 5
        button.tag = 2
        button.addTarget(self, action: #selector(typePickButton(sender:)), for: .touchUpInside)
        return button
    }()
    let Bureau : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Bureau", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 5
        button.tag = 3
        button.addTarget(self, action: #selector(typePickButton(sender:)), for: .touchUpInside)
        return button
    }()
    //---------------------------------------------------------------------
    @objc func typePickButton(sender: UIButton){
        self.selectedType = sender.tag
        switch sender.tag{
        case 1:
          self.Habitat.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
          self.Magasin.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
          self.Bureau.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
        case 2:
          self.Habitat.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
          self.Magasin.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
          self.Bureau.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
        case 3:
          self.Habitat.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
          self.Magasin.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
          self.Bureau.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
        default:
            break
        }
    }
    //---------------------------------------------------------------------
    @objc func arrivedButton(){
        stackViewAccepted.alpha = 0
        stackViewOuiNonBack_Arrived.alpha = 1
        
        //---------------------------------------------------------------------
        arrivedAnimate(){
            // what to do after animation is over
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                //************stackViewType***********
                self.view.addSubview(self.stackViewType)
                //Layout Setup
                self.stackViewType.translatesAutoresizingMaskIntoConstraints = false
                self.stackViewType.heightAnchor.constraint(equalToConstant: 60)
                self.stackViewType.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 20).isActive = true
                self.stackViewType.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                self.stackViewType.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                //************signatureViewController.view***********
                self.view.addSubview(self.signatureViewController.view)
                //Layout Setup
                self.signatureViewController.view.translatesAutoresizingMaskIntoConstraints = false
                self.signatureViewController.view.bottomAnchor.constraint(equalTo: self.stackViewOuiNonBack_Arrived.topAnchor, constant: -15).isActive = true
                self.signatureViewController.view.topAnchor.constraint(equalTo: self.stackViewType.bottomAnchor, constant: 20).isActive = true
                self.signatureViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                self.signatureViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                //************signatureClient***********
                self.view.addSubview(self.signatureClient)
                //Layout Setup
                self.signatureClient.translatesAutoresizingMaskIntoConstraints = false
                self.signatureClient.topAnchor.constraint(equalTo: self.signatureViewController.view.topAnchor, constant: 0).isActive = true
                self.signatureClient.centerXAnchor.constraint(equalTo: self.signatureViewController.view.centerXAnchor).isActive = true
                self.signatureClient.heightAnchor.constraint(equalToConstant: 20).isActive = true
            }
        
        }
    }
    func arrivedAnimate(completion: (()->Void)?){
        UIView.animate(withDuration: 0.2) {
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 4 / 10
            self.view.layoutIfNeeded()
        }
        completion?()
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
        if (self.OuiButton_Arrived.alpha != 1){
            print("Signature manquante")
        } else {
             print("Envoyer Signature")
            print("le type est: \(selectedType)")
        }
    }
    @objc func nonButton_Arrived(){
       
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 2 / 10
            self.view.layoutIfNeeded()
            
            self.selectedType = 1
            self.Habitat.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
            self.Magasin.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
            self.Bureau.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
            self.signatureViewController.reset()
            self.signatureViewController.view.removeFromSuperview()
            self.signatureClient.removeFromSuperview()
            self.stackViewType.removeFromSuperview()
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
    func signatureDrawingViewControllerIsEmptyDidChange(controller: SignatureDrawingViewController, isEmpty: Bool) {
        if (isEmpty) {
            self.OuiButton_Arrived.alpha = 0.5
        }
        else {
            self.OuiButton_Arrived.alpha = 1
        }
    }
     //---------------------------------------------------------------------
  
    override func viewWillDisappear(_ animated: Bool) {
        self.OuiButton_Arrived.alpha = 0.5
        self.signatureViewController.reset()
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
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
        //**************signatureView**************
        signatureViewController.delegate = self
        addChild(signatureViewController)
        signatureViewController.didMove(toParent: self)
        signatureViewController.view.backgroundColor = UIColor(white: 230/255, alpha: 1)
//        signatureViewController.view.layer.shadowColor = UIColor(ciColor: .black).cgColor
//        signatureViewController.view.layer.shadowOffset = CGSize(width: 0, height: 1);
//        signatureViewController.view.layer.shadowOpacity = 1;
//        signatureViewController.view.layer.shadowRadius = 1.0;
//        signatureViewController.view.clipsToBounds = false;
       
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
