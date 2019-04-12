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
import LTHRadioButton

class CourseDetailsController: UIViewController, SignatureDrawingViewControllerDelegate, ENSideMenuDelegate {
    let viewModel = CourseDetailViewModel(CourseDetailRepository: CourseDetailRepository())
    private let signatureViewController = SignatureDrawingViewController()
    //----------
    //classes
    class OuiNonButton: UIButton {
        var yes = Bool()
        var phase = String()
    }
    //---------
    var mapView = GMSMapView()
    var mapViewHeightConstraint: NSLayoutConstraint!
    var bottomViewHeightConstraint: NSLayoutConstraint!
    //---------
    //data from HomeViewController
    var statusCode:String = ""
    var latitudeDepart:Double = 0
    var longitudeDepart:Double = 0
    var latitudeArrivee:Double = 0
    var longitudeArrivee:Double = 0
    var adresseDepart: String = ""
    var adresseArrivee: String = ""
    //---------
    //local
    var selectedType = 1
    var CancelCause = ""
    var signatureImage: UIImage?
    //---------
    //views
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
 
    lazy var radioButtonsStackView1: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [radioButton11, radioButton21, radioButton3, radioButton4])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.backgroundColor = .orange
        sv.distribution = .fillEqually
        sv.spacing = 20
        return sv
    }()
    lazy var radioButtonsStackView2: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [radioButton12, radioButton22, radioButton3, radioButton4])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.backgroundColor = .orange
        sv.distribution = .fillEqually
        sv.spacing = 20
        return sv
    }()
//    lazy var LabelsStackView: UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [causeLabel1, causeLabel2, causeLabel3, causeLabel4])
//        sv.translatesAutoresizingMaskIntoConstraints = false
//        sv.axis = .vertical
//        sv.distribution = .fillEqually
//        sv.spacing = 20
//        return sv
//    }()
    lazy var autreTextView: UITextView = {
        let tv = UITextView()
        tv.alpha = 0
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 10
        tv.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        tv.backgroundColor = UIColor(white: 0, alpha: 0.1)
        tv.textColor = .darkGray
        return tv
    }()
   
    let causeLabel11 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "Client absent"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    let causeLabel12 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "J'ai eu une panne"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    let causeLabel21 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "Marchandise non adaptée"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    let causeLabel22 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "J'ai eu un accident"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    let causeLabel3 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "Rue inaccessible"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    let causeLabel4 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "Autre"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    let radioButton11 : LTHRadioButton = {
        let rb = LTHRadioButton(selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
    }()
    let radioButton12 : LTHRadioButton = {
        let rb = LTHRadioButton(selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
    }()
    let radioButton21 : LTHRadioButton = {
        let rb = LTHRadioButton(selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
    }()
    let radioButton22 : LTHRadioButton = {
        let rb = LTHRadioButton(selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
    }()
    let radioButton3 : LTHRadioButton = {
        let rb = LTHRadioButton(selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
    }()
    let radioButton4 : LTHRadioButton = {
        let rb = LTHRadioButton(selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
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
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
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
    let OuiButton_Go : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = true
        button.phase = "GO"
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let NonButton_Go : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = false
        button.phase = "GO"
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
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
    let confirmationLabel_Go : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Confirmer votre choix?"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
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
        let sv = UIStackView(arrangedSubviews: [ArrivedButton, CancelButton_Arrived])
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
    let CancelButton_Arrived : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Annuler", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cancelButton_Arrived), for: .touchUpInside)
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
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_Arrived, BackButton7])
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
    let OuiButton_Arrived : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = true
        button.phase = "ARRIVED"
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let NonButton_Arrived : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = false
        button.phase = "ARRIVED"
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let BackButton7 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let confirmationLabel_Arrived : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Êtes-vous sûr?"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    //---------------------------------------------------------------------
    lazy var stackViewPickup: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewConfirmOrCancel, BackButton6])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewConfirmOrCancel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ConfirmButton, CancelButton_Pickup])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let ConfirmButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirmer", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.alpha = 0.5
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(confirmButton), for: .touchUpInside)
        return button
    }()
    let CancelButton_Pickup : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Annuler", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cancelButton_Pickup), for: .touchUpInside)
        return button
    }()
    let BackButton6 : UIButton = {
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
    lazy var stackViewOuiNonBack_Pickup: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_Pickup, BackButton3])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewOuiNon_Pickup: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [OuiButton_Pickup, NonButton_Pickup])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let OuiButton_Pickup : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = true
        button.phase = "PICKUP"
        button.setTitle("Oui", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let NonButton_Pickup : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = false
        button.phase = "PICKUP"
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
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
    let confirmationLabel_Pickup : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Êtes-vous sûr?"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
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
    let OuiButton_Cancel : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = true
        button.phase = "CANCEL"
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let NonButton_Cancel : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = false
        button.phase = "CANCEL"
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
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
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 2.5 / 10
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            self.stackViewAccepted.alpha = 0
            self.stackViewOuiNonBack_Arrived.alpha = 1
            
            self.view.addSubview(self.confirmationLabel_Arrived)
            //Layout Setup
            self.confirmationLabel_Arrived.translatesAutoresizingMaskIntoConstraints = false
            self.confirmationLabel_Arrived.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 25).isActive = true
            self.confirmationLabel_Arrived.centerXAnchor.constraint(equalTo: self.bottomView.centerXAnchor).isActive = true
            //            self.confirmationLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor, constant: 20).isActive = true
        }
        //---------------------------------------------------------------------

    }
    func arrivedAnimate(completion: (()->Void)?){
        UIView.animate(withDuration: 0.2) {
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 4 / 10
            self.view.layoutIfNeeded()
        }
        completion?()
    }
    @objc func finishButton(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 4 / 10
            self.view.layoutIfNeeded()
        })
//        stackViewAccepted.alpha = 0
//        stackViewOuiNonBack_Cancel.alpha = 1
    }
    
    @objc func confirmButton(){
        if (self.ConfirmButton.alpha != 1){
            print("Signature manquante")
        } else {
//            print("Envoyer Signature")
//            print("le type est: \(selectedType)")
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.bottomViewHeightConstraint.constant = self.view.frame.height * 2.5 / 10
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.stackViewType.removeFromSuperview()
                self.signatureViewController.view.removeFromSuperview()
                self.signatureClient.removeFromSuperview()
                self.stackViewPickup.alpha = 0
                self.stackViewOuiNonBack_Pickup.alpha = 1
                
                self.view.addSubview(self.confirmationLabel_Pickup)
                //Layout Setup
                self.confirmationLabel_Pickup.translatesAutoresizingMaskIntoConstraints = false
                self.confirmationLabel_Pickup.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 25).isActive = true
                self.confirmationLabel_Pickup.centerXAnchor.constraint(equalTo: self.bottomView.centerXAnchor).isActive = true
            }
        }
        
       
//        UIView.animate(withDuration: 0.2, animations: { () -> Void in
//            self.bottomViewHeightConstraint.constant = self.view.frame.height * 4 / 10
//            self.view.layoutIfNeeded()
//        })
//        //        stackViewAccepted.alpha = 0
//        //        stackViewOuiNonBack_Cancel.alpha = 1
    }
    fileprivate func GetCancelCause1() {
        radioButton11.select()

        //**************stackViewCancelCauses**************
        bottomView.addSubview(radioButtonsStackView1)
        //Layout Setup
        radioButtonsStackView1.translatesAutoresizingMaskIntoConstraints = false
        radioButtonsStackView1.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15).isActive = true
        radioButtonsStackView1.bottomAnchor.constraint(equalTo: stackViewOuiNonBack_Cancel.topAnchor, constant: -20).isActive = true
        radioButtonsStackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        radioButtonsStackView1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        bottomView.addSubview(causeLabel11)
        bottomView.addSubview(causeLabel21)
        bottomView.addSubview(causeLabel3)
        bottomView.addSubview(causeLabel4)
        //Layout Setup
        causeLabel11.translatesAutoresizingMaskIntoConstraints = false
        causeLabel21.translatesAutoresizingMaskIntoConstraints = false
        causeLabel3.translatesAutoresizingMaskIntoConstraints = false
        causeLabel4.translatesAutoresizingMaskIntoConstraints = false
        causeLabel11.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 40).isActive = true
        causeLabel21.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 40).isActive = true
        causeLabel3.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 40).isActive = true
        causeLabel4.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 40).isActive = true
        causeLabel11.centerYAnchor.constraint(equalTo: radioButton11.centerYAnchor).isActive = true
        causeLabel21.centerYAnchor.constraint(equalTo: radioButton21.centerYAnchor).isActive = true
        causeLabel3.centerYAnchor.constraint(equalTo: radioButton3.centerYAnchor).isActive = true
        causeLabel4.centerYAnchor.constraint(equalTo: radioButton4.centerYAnchor).isActive = true
        //**************stackViewCancelCauses**************
        bottomView.addSubview(autreTextView)
        //Layout Setup
        autreTextView.translatesAutoresizingMaskIntoConstraints = false
        autreTextView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
        autreTextView.bottomAnchor.constraint(equalTo: stackViewOuiNonBack_Cancel.topAnchor, constant: -20).isActive = true
        autreTextView.leadingAnchor.constraint(equalTo: causeLabel11.trailingAnchor, constant: 10).isActive = true
        autreTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    fileprivate func GetCancelCause2() {
        radioButton12.select()

        //**************stackViewCancelCauses**************
        bottomView.addSubview(radioButtonsStackView2)
        //Layout Setup
        radioButtonsStackView2.translatesAutoresizingMaskIntoConstraints = false
        radioButtonsStackView2.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15).isActive = true
        radioButtonsStackView2.bottomAnchor.constraint(equalTo: stackViewOuiNonBack_Cancel.topAnchor, constant: -20).isActive = true
        radioButtonsStackView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        radioButtonsStackView2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        bottomView.addSubview(causeLabel12)
        bottomView.addSubview(causeLabel22)
        bottomView.addSubview(causeLabel3)
        bottomView.addSubview(causeLabel4)
        
        causeLabel12.translatesAutoresizingMaskIntoConstraints = false
        causeLabel22.translatesAutoresizingMaskIntoConstraints = false
        causeLabel3.translatesAutoresizingMaskIntoConstraints = false
        causeLabel4.translatesAutoresizingMaskIntoConstraints = false
        
        causeLabel12.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 40).isActive = true
        causeLabel22.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 40).isActive = true
        causeLabel3.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 40).isActive = true
        causeLabel4.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 40).isActive = true
        
        causeLabel12.centerYAnchor.constraint(equalTo: radioButton12.centerYAnchor).isActive = true
        causeLabel22.centerYAnchor.constraint(equalTo: radioButton22.centerYAnchor).isActive = true
        causeLabel3.centerYAnchor.constraint(equalTo: radioButton3.centerYAnchor).isActive = true
        causeLabel4.centerYAnchor.constraint(equalTo: radioButton4.centerYAnchor).isActive = true
        
        bottomView.addSubview(autreTextView)
        //Layout Setup
        autreTextView.translatesAutoresizingMaskIntoConstraints = false
        autreTextView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
        autreTextView.bottomAnchor.constraint(equalTo: stackViewOuiNonBack_Cancel.topAnchor, constant: -20).isActive = true
        autreTextView.leadingAnchor.constraint(equalTo: causeLabel12.trailingAnchor, constant: 10).isActive = true
        autreTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    @objc func cancelButton_Arrived(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 4 / 10
            self.view.layoutIfNeeded()
        })
        stackViewAccepted.alpha = 0
        stackViewOuiNonBack_Cancel.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            self.GetCancelCause2()
        }
        self.NonButton_Cancel.phase = "CANCEL_FROM_ACCEPTED"
        self.OuiButton_Cancel.phase = "CANCEL_FROM_ACCEPTED"
    }
    @objc func cancelButton_Pickup(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 4 / 10
            self.view.layoutIfNeeded()
        })
        self.stackViewType.removeFromSuperview()
        self.signatureViewController.view.removeFromSuperview()
        self.signatureClient.removeFromSuperview()
        stackViewPickup.alpha = 0
        stackViewOuiNonBack_Cancel.alpha = 1
        GetCancelCause1()
        self.NonButton_Cancel.phase = "CANCEL_FROM_PICKUP"
        self.OuiButton_Cancel.phase = "CANCEL_FROM_PICKUP"

    }
    @objc func goButton(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.view.frame.height * 2.5 / 10
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

        self.stackViewAssigned.alpha = 0
        self.stackViewOuiNonBack_Go.alpha = 1
        
        self.view.addSubview(self.confirmationLabel_Go)
        //Layout Setup
        self.confirmationLabel_Go.translatesAutoresizingMaskIntoConstraints = false
        self.confirmationLabel_Go.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 25).isActive = true
        self.confirmationLabel_Go.centerXAnchor.constraint(equalTo: self.bottomView.centerXAnchor).isActive = true
//            self.confirmationLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor, constant: 20).isActive = true
      }
    }
    @objc func OuiNonHandler(sender: OuiNonButton){
        switch sender.phase{
        case "GO":
            if (sender.yes){
                 print("OUI GO")
            }else{
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.view.frame.height * 2 / 10
                    self.confirmationLabel_Go.removeFromSuperview()
                    self.view.layoutIfNeeded()
                })
                stackViewAssigned.alpha = 1
                stackViewOuiNonBack_Go.alpha = 0
            }
        case "ARRIVED":
            if (sender.yes){
                arrivedAnimate(){
                    // what to do after animation is over
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.stackViewOuiNonBack_Arrived.alpha = 0
                        self.stackViewPickup.alpha = 1
                        self.confirmationLabel_Arrived.removeFromSuperview()
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
            }else{
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.view.frame.height * 2 / 10
                    self.confirmationLabel_Arrived.removeFromSuperview()
                    self.view.layoutIfNeeded()
                })
                
                stackViewAccepted.alpha = 1
                stackViewOuiNonBack_Arrived.alpha = 0
            }
        case "PICKUP":
            if (sender.yes){
                print("Envoyer Signature")
                print("le type est: \(selectedType)")
            }else{
                arrivedAnimate(){
                    // what to do after animation is over
                    self.selectedType = 1
                    self.Habitat.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
                    self.Magasin.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
                    self.Bureau.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
                    self.signatureViewController.reset()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.stackViewOuiNonBack_Pickup.alpha = 0
                        self.stackViewPickup.alpha = 1
                        self.confirmationLabel_Pickup.removeFromSuperview()
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
        case "CANCEL_FROM_ACCEPTED":
            if (sender.yes ){
                if (self.autreTextView.text != ""){
                    doCancel(cause: autreTextView.text)
                } else {
                    doCancel(cause: CancelCause)
                }
            }else{
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        self.bottomViewHeightConstraint.constant = self.view.frame.height * 2 / 10
                        self.view.layoutIfNeeded()
                    })
                    stackViewAccepted.alpha = 1
                    stackViewOuiNonBack_Cancel.alpha = 0
                    causeLabel12.removeFromSuperview()
                    causeLabel22.removeFromSuperview()
                    causeLabel3.removeFromSuperview()
                    causeLabel4.removeFromSuperview()
                    radioButtonsStackView2.removeFromSuperview()
//                    LabelsStackView.removeFromSuperview()
                    autreTextView.removeFromSuperview()
               
            }
        case "CANCEL_FROM_PICKUP":
            if (sender.yes ){
                if (self.CancelCause == "La course a été annulée pour d'autres raisons"){
                    if(self.autreTextView.text != ""){
                        doCancel(cause: autreTextView.text)
                    } else {
                        doCancel(cause: CancelCause)
                    }
                }else{
                    doCancel(cause: CancelCause)
                }
            }else{
                arrivedAnimate(){
                    // what to do after animation is over
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.stackViewPickup.alpha = 1
                        self.stackViewOuiNonBack_Cancel.alpha = 0
                        self.confirmationLabel_Arrived.removeFromSuperview()
                        self.radioButtonsStackView1.removeFromSuperview()
                        self.causeLabel11.removeFromSuperview()
                        self.causeLabel21.removeFromSuperview()
                        self.causeLabel3.removeFromSuperview()
                        self.causeLabel4.removeFromSuperview()
                        self.autreTextView.removeFromSuperview()
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
        default:
            break
        }
    }
    func doCancel(cause:String){
        print(cause)
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
            self.ConfirmButton.alpha = 0.5
        }
        else {
            self.ConfirmButton.alpha = 1
            self.signatureImage = signatureViewController.fullSignatureImage
        }
    }
     //---------------------------------------------------------------------
  
    override func viewWillDisappear(_ animated: Bool) {
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
        if statusCode == "ASSIGNED"{
            stackViewAssigned.alpha = 1
            stackViewAccepted.alpha = 0
            stackViewPickup.alpha = 0
        } else if statusCode == "ACCEPTEE" {
            stackViewAssigned.alpha = 0
            stackViewPickup.alpha = 0
            stackViewAccepted.alpha = 1
        } else if statusCode == "LIVRAISON" {
            stackViewAssigned.alpha = 0
            stackViewAccepted.alpha = 0
            stackViewPickup.alpha = 0
            print("LIVRAISON")
        } else if statusCode == "ENLEVEMENT" {
            stackViewAssigned.alpha = 0
            stackViewAccepted.alpha = 0
            stackViewPickup.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                self.bottomViewHeightConstraint.constant = self.view.frame.height * 4 / 10
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
           
            

           print("ENLEVEMENT")
        } else  {
            stackViewAssigned.alpha = 0
            stackViewAccepted.alpha = 0
            print("ELSE")
        }
    //----------------------------------
        //CANCEL CAUSES SETUP
        radioButton11.select()
        radioButton12.select()

        radioButton11.onSelect {
            self.radioButton21.deselect()
            self.radioButton3.deselect()
            self.radioButton4.deselect()
            self.CancelCause = "Client absent"
        }
        radioButton12.onSelect {
            self.radioButton22.deselect()
            self.radioButton3.deselect()
            self.radioButton4.deselect()
            self.CancelCause = "J'ai eu une panne"
        }
        radioButton21.onSelect {
            self.radioButton11.deselect()
            self.radioButton3.deselect()
            self.radioButton4.deselect()
            self.CancelCause = "Marchandise non adaptée"
        }
        radioButton22.onSelect {
            self.radioButton12.deselect()
            self.radioButton3.deselect()
            self.radioButton4.deselect()
            self.CancelCause = "J'ai eu un accident"
        }
        radioButton3.onSelect {
            self.radioButton11.deselect()
            self.radioButton21.deselect()
            self.radioButton12.deselect()
            self.radioButton22.deselect()
            self.radioButton4.deselect()
            self.CancelCause = "Rue inaccessible"
        }
        radioButton4.onSelect {
            self.radioButton11.deselect()
            self.radioButton21.deselect()
            self.radioButton12.deselect()
            self.radioButton22.deselect()
            self.radioButton3.deselect()
            UIView.animate(withDuration: 0.2, animations: {
                self.autreTextView.alpha = 1
            })
            self.CancelCause = "La course a été annulée pour d'autres raisons"
        }
        radioButton4.onDeselect {
            self.autreTextView.text = ""
            UIView.animate(withDuration: 0.2, animations: {
                self.autreTextView.alpha = 0
            })
        }
        //**************stackViewPickup**************
        bottomView.addSubview(stackViewPickup)
        //Layout Setup stackViewAccepted
        stackViewPickup.translatesAutoresizingMaskIntoConstraints = false
        stackViewPickup.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
        stackViewPickup.heightAnchor.constraint(equalToConstant: bottomViewHeightConstraint.constant - 50).isActive = true
        stackViewPickup.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackViewPickup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //**************stackViewAccepted**************
        bottomView.addSubview(stackViewAccepted)
        //Layout Setup stackViewAccepted
        stackViewAccepted.translatesAutoresizingMaskIntoConstraints = false
        stackViewAccepted.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
        stackViewAccepted.heightAnchor.constraint(equalToConstant: bottomViewHeightConstraint.constant - 50).isActive = true
        stackViewAccepted.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackViewAccepted.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //**************stackViewAssigned**************
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
        //**************stackViewOuiNonBack_Pickup**************
        bottomView.addSubview(stackViewOuiNonBack_Pickup)
        stackViewOuiNonBack_Pickup.alpha = 0
        //Layout Setup
        stackViewOuiNonBack_Pickup.translatesAutoresizingMaskIntoConstraints = false
        stackViewOuiNonBack_Pickup.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
        stackViewOuiNonBack_Pickup.heightAnchor.constraint(equalToConstant: bottomViewHeightConstraint.constant - 50).isActive = true
        stackViewOuiNonBack_Pickup.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackViewOuiNonBack_Pickup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
       
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
